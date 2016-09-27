Rails.application.routes.draw do
  resources :users
  get 'users/login'
end
