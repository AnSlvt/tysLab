require 'net/http'

class UsersController < ApplicationController

  def login
    get_request_code if @state == nil
    get_access_token if @access_token == nil
    client = Octokit::Client.new(access_token: @access_token)
    @user = client.user
  end

  private @state = nil
  private @access_token = nil
  private @@client_id = 'd64b686c8f0aa243775d'
  private @@client_secret = '54e803105611548081f92ea6a90d59ec31358b98'

  private

  def get_request_code
    uri = URI("https://github.com/login/oauth/authorize")
    @state = SecureRandom.base64
    params = { client_id: @@client_id,
               scope: ["user", "repo"],
               state: @state }
    uri.query = URI.encode_www_form(params)
    Net::HTTP.get_response(uri)
  end

  def get_access_token
    prm = params[:code]
    uri = URI('https://github.com/login/oauth/access_token')
    res = Net::HTTP.post_form(uri, 'q' => [@@client_id,
                                           @@client_secret,
                                           prm,
                                           @state])
    @access_token = res.access_token
  end

end
