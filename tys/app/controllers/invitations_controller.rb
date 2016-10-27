class InvitationsController < ApplicationController

  before_action :logged_in?, except: :accept
  before_action :is_allowed, only: :destroy

  # POST /users/:user_id/applications/:application_id/invitations
  def create

    # Create a new entry for the invitations table only if it's a new request
    @invite = Invitation.find_by(leader_name: current_user.name,
                                target_name: params[:user_id],
                                application_id: params[:application_id])
    @application = Application.find(params[:application_id])
    @target = User.find(params[:user_id])
    render file: 'public/404.html', status: 403 and return unless session[:user_id] == @application.author
    render file: 'public/404.html', status: 403 and return if @target.in?(@application.users)

    # If the invitation already exists send the email with the previous token
    # create a new token and an entry in the table otherwise
    if @invite
      token = @invite.invite_token
    else
      token = SecureRandom.hex(64)
      @invite = Invitation.create!({
            leader_name: current_user.name,
            target_name: params[:user_id],
            application_id: params[:application_id],
            invite_token: token.to_s
      })
    end

    link = user_application_invitation_accept_invitation_url(
                              @target, @application, @invite, token)
    InvitationNotificationMailer.invitation_mail(
                                current_user.name,
                                @target,
                                @application.application_name,
                                link).deliver_now
    flash[:notice] = "#{params[:user_id]} invited to #{@application.application_name}"
  end

  # DELETE /users/:user_id/applications/:application_id/invitations/:id
  def destroy
    @invitation = Invitation.find(params[:id])
    render file: 'public/404', status: 403 and return unless @invitation.target_name == current_user.name || current_user.name == @invitation.leader_name
    @invitation.destroy
    redirect_to user_applications_path(current_user)
  end

  private

  def is_allowed
    unless params[:user_id] == session[:user_id] || session[:user_id]
      render file: "public/404.html", status: 403 and return
    end
  end

end
