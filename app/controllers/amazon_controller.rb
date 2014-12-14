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
          b = Book.new(asin:book[:asin], title:book[:title], url:book[:url], image:book[:image])
          b.save
        end
      rescue
        puts book
      end
    end

    links = results[:links]
    links.each do |link|
      begin
        if l = Link.where(from_asin:link[:from_asin], to_asin:link[:to_asin])
          l = Link.new(from_asin:link[:from_asin], from_title:link[:from_title], to_asin:link[:to_asin], to_title:link[:to_title])
          l.save
        end
      rescue
        puts link
      end
    end

    redirect_to books_path
  end
end
