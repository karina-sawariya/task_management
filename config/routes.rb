Rails.application.routes.draw do
  resources :users, only: [:create]
  post '/auth/login', to: 'authentication#login'
end
