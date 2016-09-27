require 'net/http'

class UsersController < ApplicationController

  @@state = ""
  @access_token = ""
  @@client_id = 'd64b686c8f0aa243775d'
  @@client_secret = '54e803105611548081f92ea6a90d59ec31358b98'

  def login
    if @@state.to_s == ""
      logger.info "Starting method to request for code..."
      get_request_code
    else
      code = params[:code]
      logger.info "Code received, requesting the access token"
      get_access_token(code)
      @@state = ""
      logger.info "Access token received #{@access_token}"
      client = Octokit::Client.new(access_token: @access_token)
      @user = client.user
      logger.info "#{@user.login}"
    end
  end

  private

  def get_request_code
    logger.info "Starting request to github auth method"
    uri = URI("https://github.com/login/oauth/authorize")
    @@state = SecureRandom.base64
    params = { client_id: @@client_id.to_s,
               scope: "user,repo",
               state: @@state.to_s }
    uri.query = URI.encode_www_form(params)
    redirect_to uri.to_s, method: :get
    logger.info "#{uri}"
  end

  def get_access_token(code)
    logger.info "Starting request for access_token convertion"
    uri = URI('https://github.com/login/oauth/access_token')
    prm = { client_id: @@client_id,
            client_secret: @@client_secret,
            code: code,
            state: @@state }
    uri.query = URI.encode_www_form(prm)
    res = Net::HTTP.post_form(uri, "q" => uri.query)
    temp = res.body.scan(/\=[a-z0-9]*&/)[0]
    @access_token = temp.slice(1, temp.size - 2)
    logger.info "Access token set up #{@access_token}"
    return
  end

end
