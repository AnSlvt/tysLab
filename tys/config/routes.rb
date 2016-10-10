Rails.application.routes.draw do

  root to: "homepage#index"
  get "/search_results" => "homepage#search"

  # Users routes and applications routes
  resources :users, only: :show do
    get "applications/:id/show_public" => "applications#show_public", as: "application_show_public"
    resources :applications do
      resources :stack_traces
    end
  end

  resources :application, only: '' do
    resources :feedbacks
  end

  get 'users_login' => 'users#login'
  get 'users_authorize' => 'users#authorize'
  get 'users_logout' => 'users#logout'

  get "stacktraces/:id/details" => "stacktraces#show_details"

end
