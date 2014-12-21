class AmazonController < ApplicationController
  def search
    if params[:keyword]
      results = AmazonUtil::search_amazon(params[:keyword])
      @books = results[:books]
      @links = results[:links]
    else
      @books = []
      @links = []
    end
  end

  def crawl
    if params[:keyword]
      results = AmazonUtil::crawl_amazon(params[:keyword]) if params[:keyword]
    else
      results = {books:[], links:[]}
    end

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
          l.update({from_asin:link[:from_asin], from_title:link[:from_title], to_asin:link[:to_asin], to_title:link[:to_title]})
        else
          l = Link.new({from_asin:link[:from_asin], from_title:link[:from_title], to_asin:link[:to_asin], to_title:link[:to_title]})
        end
        l.save
      rescue
        puts "ERROR: Link insert or update: #{l}"
      end
    end

    redirect_to books_path
  end

  def expand

    redirect_to books_path
  end

  def complete
    books = Book.where(url:nil)
    books.each do |book|
      begin
        results = AmazonUtil::lookup_amazon(book.asin)
        book.update(results[:books].first)
        book.save
      rescue
        puts "WARNING: lookup was failed: #{book.asin}:#{book.title}"
        sleep 2
      ensure 
        sleep 1
      end
    end

    redirect_to books_path
  end
end

