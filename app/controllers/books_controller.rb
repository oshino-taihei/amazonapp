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
