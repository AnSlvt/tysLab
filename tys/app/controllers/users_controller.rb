require 'net/http'
require_relative '../../lib/session_handler.rb'

class UsersController < ApplicationController

  before_action :logged_in?, only: [:send_subscribe_mail, :show, :edit, :update]
  after_action :notification, only: :authorize

  @@state = ""

  def login
    get_request_code
  end

  def authorize
    code = params[:code]
    access_token = get_access_token(code)
    @@state = ""
    client = Octokit::Client.new(access_token: access_token)
    SessionHandler.instance(client)
    user = client.user
    session[:user_id] = user.login.to_s
    flash[:notice] = "#{user.login} succesfully logged in!"
    @user = User.find_by(name: user.login.to_s)
    unless @user
      begin
        @user = User.create!(name: user.login.to_s,
                             email: client.emails[0][:email].to_s)
      rescue RecordInvalid
        render file: 'public/500.html', status: 500 and return
      end
    end

    redirect_to user_applications_path(current_user), method: :get and return
  end

  def send_subscribe_mail
    link = root_url.to_s
    SubscribeMailer.subscribe_mail(current_user.name, params[:email], link).deliver_now
    redirect_to user_applications_path(session[:user_id]), notice: "Invitation sent!"
  end

  def show
    @user = User.find_by(name: params[:id])
    render file: 'public/404.html', status: 404 and return unless @user
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

  def show
    @user = User.find_by(name: params[:id])
    render file: 'public/404.html', status: 404 and return unless @user
  end

  def show_public
    @user = User.find_by(name: params[:user_id])
    render file: 'public/404.html', status: 404 and return unless @user
    @applications = Application.where(author: params[:user_id])
  end

  def edit
    @user = User.find_by(name: params[:id])
    render file: 'public/404.html', status: 404 and return unless @user
    render file: 'public/403.html', status: 403 and return unless current_user.name == params[:id]
  end

  def update
    user = User.find_by(name: params[:id])
    render file: 'public/404.html', status: 404 and return unless user
    render file: 'public/403.html', status: 403 and return unless current_user.name == params[:id]
    user.update({ secondary_email: params[:secondary_email], phone: params[:phone], bio: params[:bio] })
    redirect_to user_path(user)
  end

  private

  def get_request_code
    uri = URI("https://github.com/login/oauth/authorize")
    logger.info "redirect_to #{uri}"
    @@state = SecureRandom.urlsafe_base64(nil, true)
    params = { client_id: ENV['client_id'],
               scope: "user,repo",
               state: @@state.to_s }
    uri.query = URI.encode_www_form(params)
    redirect_to uri.to_s, method: :get and return
  end

  def get_access_token(code)
    uri = URI('https://github.com/login/oauth/access_token')
    logger.info "redirect_to #{uri}"
    prm = { client_id: ENV['client_id'],
            client_secret: ENV['client_secret'],
            code: code,
            state: @@state }
    uri.query = URI.encode_www_form(prm)
    res = Net::HTTP.post_form(uri, "q" => uri.query)
    res.body.scan(/\=([a-z0-9]*)&/)[0][0]
  end
end
