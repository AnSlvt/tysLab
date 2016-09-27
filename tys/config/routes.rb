Rails.application.routes.draw do
  root to: "homepage#index"
  #resources :users
  get 'users/login' => 'users#login'
end
