Rails.application.routes.draw do
  resources :posts, only: [:index, :show]
  resources :sathread, only: [:index, :show]
  resources :users, only: [:index, :show]
  root to: 'sathread#index'
end
