Rails.application.routes.draw do
  root 'books#index'

  get 'amazon/search'
  get 'amazon/crawl'

  get 'books/viz'
  resources:books
end
