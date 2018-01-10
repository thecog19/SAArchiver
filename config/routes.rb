Rails.application.routes.draw do
  resources :posts, only: [:index, :show]
  resources :sathread, only: [:index, :show]
  resources :users, only: [:index, :show]
  get '/posts/bythread/:thread_id/', to: 'posts#posts_by_thread'
  get '/thread/:thread_id/strictsearch/:search_term/', to: 'sathread#strict_search'
  get '/thread/:thread_id/fuzzysearch/:search_term/', to: 'sathread#fuzzy_search'
  get '/thread/:thread_id/user/:user_id/', to: 'sathread#user_in_thread_posts'
  get '/thread/:thread_id/user/:user_id/:search_type/:search_term', to: 'sathread#search_user_in_thread_posts'
  get '/users/strictsearch/:search_term', to: 'users#strict_search'
  get '/users/fuzzysearch/:search_term', to: 'users#fuzzy_search'


  root to: 'sathread#index'
end
