Rails.application.routes.draw do
  get 'amazon/search'
  get 'amazon/crawl'

  #root 'books#index'
  root 'amazon#search'
  resources:books
end
