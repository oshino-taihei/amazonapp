class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @links = Link.where(from_id: @book.asin)
  end
end
