class AmazonController < ApplicationController
  def search
    @results = AmazonUtil::search_amazon(params[:search][:keyword])
  end
end
