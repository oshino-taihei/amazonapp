class AmazonController < ApplicationController
  def search
    if params[:search]
      @results = AmazonUtil::search_amazon(params[:search][:keyword]) if params[:search]
    else
      @results = {books:[], links:[]}
    end
  end
end
