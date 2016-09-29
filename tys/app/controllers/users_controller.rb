require 'net/http'

class UsersController < ApplicationController

  @@state = ""

  def login
    if @@state.to_s == ""
      get_request_code
    else
      code = params[:code]
      access_token = get_access_token(code)
      @@state = ""
      client = Octokit::Client.new(access_token: access_token)
      user = client.user
      session[:user_id] = user.login.to_s
      flash[:notice] = "#{user.login} succesfully logged in!"
      @user = User.find_by(name: user.login.to_s)
      if (!@user)
        begin
          @user = User.create!(name: user.login.to_s,
                               email: client.emails[0][:email].to_s)
        rescue RecordInvalid
          render file: 'public/500.html' and return
        end
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to '/'
    flash[:notice] = "Logged out!"
  end

  private

  def get_request_code
    uri = URI("https://github.com/login/oauth/authorize")
    @@state = SecureRandom.base64
    params = { client_id: ENV['client_id'],
               scope: "user,repo",
               state: @@state.to_s }
    uri.query = URI.encode_www_form(params)
    redirect_to uri.to_s, method: :get
  end

  def get_access_token(code)
    uri = URI('https://github.com/login/oauth/access_token')
    prm = { client_id: ENV['client_id'],
            client_secret: ENV['client_secret'],
            code: code,
            state: @@state }
    uri.query = URI.encode_www_form(prm)
    res = Net::HTTP.post_form(uri, "q" => uri.query)
    reg_try = res.body.scan(/\=([a-z0-9]+)&\1 in/)
    logger.info "REGEX #{reg_try}"
    temp = res.body.scan(/\=[a-z0-9]*&/)[0]
    temp.slice(1, temp.size - 2)
  end

end
