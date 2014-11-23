Rails.application.routes.draw do
  get 'amazon/search'

  root 'books#index'
  resources:books
end
