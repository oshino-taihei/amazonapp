Rails.application.routes.draw do
  root 'books#index'

  get 'amazon/search'
  get 'amazon/crawl'

  get 'books/viz'
  get 'books/complete'
  resources:books
end
