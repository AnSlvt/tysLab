class InvitationsController < ApplicationController

  before_action :logged_in?, except: :accept
  before_action :is_allowed, only: :destroy

  def create
    @application = Application.find(params[:application_id])
    @user = User.find(params[:user_id])
    render file: 'public/404.html', status: 403 and return if @user.in?(@application.users)
    token = SecureRandom.hex(64)
    @invite = Invitation.create!({
          leader_name: current_user.name,
          target_name: params[:user_id],
          application_id: params[:application_id],
          invite_token: token.to_s
    })
    link = user_application_invitation_accept_invitation_url(
                              @user, @application, @invite, token)
    InvitationNotificationMailer.invitation_mail(
                                current_user.name,
                                @user,
                                @application.application_name,
                                link).deliver_now
    flash[:notice] = "#{params[:user_id]} invited to #{@application.application_name}"
  end

  def accept
    invitation = Invitation.find(params[:invitation_id])
    token = params[:token]
    # TODO: change 404 with a better page
    render file: "public/404.html" and return unless token.to_s == invitation.invite_token
    leader = User.find_by(name: invitation.leader_name)
    invitation.destroy
    Contributor.create!({
      user_id: params[:user_id],
      application_id: params[:application_id]
    })
    redirect_to user_application_path(leader, params[:application_id]), method: :get
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    user = @invitation.target_name
    @invitation.destroy
    redirect_to user_applications_path(user)
  end

  private

  def is_allowed
    unless params[:user_id] == session[:user_id]
      render file: "public/404.html", status: 403 and return
    end
  end

end
