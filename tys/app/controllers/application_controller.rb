class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :notification

  private

  def current_user
    @current_user ||= User.find_by(name: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    unless session[:user_id]
      render file: "public/401.html", status: 401 and return
    end
  end

  def notification
    ActiveSupport::Notifications.subscribe('accepted') do |name, start, finish, id, payload|
      @application = Application.find(payload[:application_id])
      ContributorsMailer.invitation_accepted(payload[:contr_id]).deliver_now if @application.author == session[:user_id]
    end
  end
end
