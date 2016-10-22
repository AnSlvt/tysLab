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
    resources :contributors, only: [:index, :destroy]
    resources :feedbacks, except: [:new, :show, :index]
    get "feedbacks/:parent_id/" => "feedbacks#new", as: "new_feedback"
    post "contributors/" => "contributors#composition_mail", as: "composition_mail_tm"
    post "contributors/all" => "contributors#composition_all", as: "composition_all_tm"
    post "send_mail" => "contributors#send_mail", as: "send_mail_tm"
    post "send_all" => "contributors#send_all", as: "send_all_tm"
  end

  get "applications/:id/team_members" => "applications#team_members", as: "application_team_members"
  get 'users_login' => 'users#login'
  get 'users_authorize' => 'users#authorize'
  get 'users_logout' => 'users#logout'

end
