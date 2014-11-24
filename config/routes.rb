Rails.application.routes.draw do
  get 'amazon/search'

  #root 'books#index'
  root 'amazon#search'
  resources:books
end
