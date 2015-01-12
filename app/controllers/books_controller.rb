class BooksController < ApplicationController
  def index
    @books = search(params[:keyword])
  end

  def show
    @book = Book.find(params[:id])
    @links = Link.where(from_asin: @book.asin)
  end

  def viz
    books = search(params[:keyword])
    @books = []
    bookasin = {} # bookのasinと@books配列でのindexを記憶するHash
    books.each_with_index do |book, i|
      b = {asin:book.asin, url:book.url, title:book.title, image:book.image}
      @books << b
      bookasin[book.asin] = i
    end

    links = search_link(params[:keyword])
    @links = []
    links.each do |link|
      source = bookasin[link.from_asin]
      target = bookasin[link.to_asin]
      l = {source:source, target:target}
      @links << l if source && target
    end
  end

  def upload
    text = params[:tsvfile].read
    text.each_line do |line|
      next unless line
      s = line.force_encoding("utf-8").split(/\t/)
      asin = s[0].to_s
      title = s[1].to_s
      book = {asin: asin, url: nil, title: title, image: nil}
      begin
        unless Book.where(asin: asin).first
          b = Book.new(book)
          b.save
        end
      rescue => e
        puts "ERROR: Book insert : #{asin}:#{title}: #{e.message}"
      end
    end
    redirect_to books_path
  end

  def purge
    Link.destroy_all
    Book.destroy_all
    redirect_to books_path
  end

  private

  def search(keyword)
    if keyword
      books = Book.where('title LIKE ?', "%#{keyword}%") 
    else
      books = Book.all
    end
    return books
  end


  def search_link(keyword)
    if keyword
      links = Link.where('from_title LIKE ? OR to_title LIKE ?', "%#{keyword}%", "%#{keyword}%")
    else
      links = Link.all
    end
    return links
  end
end
