Rails.application.routes.draw do

  root to: 'homepage#index'
  get '/search_results' => 'homepage#search'
  get '/user_search' => 'homepage#search_user'

  # Users routes and applications routes
  resources :users, only: :show do
    resources :applications do
      post 'add_contribs/:repo' => 'contributors#add_github_contribs', as: 'add_github_contribs'
      resources :stack_traces
      resources :invitations, only: [:create, :destroy] do
        get "/accept/:token" => "contributors#create", as: "accept_invitation"
      end
      get '/show_public' => 'applications#show_public'
    end
  end

  resources :application, only: '' do
    resources :feedbacks
    resources :contributors, only: [:index, :destroy]
  end

  get 'users_login' => 'users#login'
  get 'users_authorize' => 'users#authorize'
  get 'users_logout' => 'users#logout'

end
