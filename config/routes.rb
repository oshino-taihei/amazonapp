Rails.application.routes.draw do
  root 'books#index'

  get 'amazon/search'
  get 'amazon/crawl'
  get 'amazon/expand'
  get 'amazon/complete'

  get 'books/viz'
  post 'books/upload'
  resources:books
end
