class AmazonController < ApplicationController
  def search
    if params[:search]
      @results = AmazonUtil::search_amazon(params[:search][:keyword]) if params[:search]
    else
      @results = {books:[], links:[]}
    end
  end

  def crawl
    results = AmazonUtil::crawl_amazon(params[:crawl][:keyword]) if params[:crawl]

    books = results[:books]
    books.each do |book|
      begin
        if b = Book.where(asin:book[:asin]).first
          b.update(book)
        else
          b = Book.new(book)
        end
        b.save
      rescue
        puts "ERROR: Book insert or update: #{b.asin}:#{b.title}"
      end
    end

    links = results[:links]
    links.each do |link|
      begin
        if l = Link.where(from_asin:link[:from_asin], to_asin:link[:to_asin]).first
          l.update(link)
        else
          l = Link.new(link)
        end
        l.save
      rescue
        puts "ERROR: Link insert or update: #{l}"
      end
    end

    redirect_to books_path
  end
end
