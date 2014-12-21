class BooksController < ApplicationController
  def index
    @books = search(params[:keyword])
  end

  def show
    @book = Book.find(params[:id])
    @links = Link.where(from_asin: @book.asin)
  end

  def viz
    books = Book.all
    @books = []
    bookasin = {} # bookのasinと@books配列でのindexを記憶するHash
    books.each_with_index do |book, i|
      b = {asin:book.asin, url:book.url, title:book.title, image:book.image}
      @books << b
      bookasin[book.asin] = i
    end

    links = Link.all
    @links = []
    links.each do |link|
      source = bookasin[link.from_asin]
      target = bookasin[link.to_asin]
      l = {source:source, target:target}
      @links << l
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
end
