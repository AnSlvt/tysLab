Rails.application.routes.draw do

  root to: "homepage#index"
  #resources :users
  get 'users/login' => 'users#login'
  get 'users/authorize' => 'users#authorize'
  get 'users/logout' => 'users#logout'
  get 'users/index' => 'users#index'

  get "applications/:id/details" => "appdetails#load_details"
  get "stacktraces/:id/details" => "stacktraces#show_details"

end
