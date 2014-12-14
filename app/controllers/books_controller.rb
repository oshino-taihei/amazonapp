class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @links = Link.where(from_asin: @book.asin)
  end
end
