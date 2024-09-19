Rails.application.routes.draw do
  root 'tasks#index'
  resources :users
  post '/auth/login', to: 'authentication#login'
  resources :tasks 
end
