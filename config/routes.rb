Rails.application.routes.draw do
  resources :posts, only: [:index, :show]
  resources :sathread, only: [:index, :show]
  resources :users, only: [:index, :show]
  get '/posts/bythread/:thread_id/', to: 'posts#posts_by_thread'
  root to: 'sathread#index'
end
