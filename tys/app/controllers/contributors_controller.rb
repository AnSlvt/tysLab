class ContributorsController < ApplicationController

  before_action :logged_in?

  def index
    @application = Application.find(params[:application_id])
  end

  # GET /users/:user_id/applications/:application_id/invitations/:invitation_id/accept/:token
  def create

    render file: 'public/404.html', status: 403 and return unless session[:user_id] == params[:user_id]

    invitation = Invitation.find(params[:invitation_id])
    token = params[:token]
    # TODO: change 404 with a better page
    render file: "public/404.html" and return unless token.to_s == invitation.invite_token
    leader = User.find_by(name: invitation.leader_name)
    invitation.destroy
    contr_id = Contributor.create!({
      user_id: params[:user_id],
      application_id: params[:application_id]
    })
    ActiveSupport::Notifications.instrument("accepted", contr_id: contr_id, application_id: params[:application_id]) do
    end
    redirect_to user_application_path(leader, params[:application_id]), method: :get
  end

  def add_github_contribs

    # Control if the user is allowed
    render file: 'public/404.html', status: 404 and return unless session[:user_id] == params[:user_id]

    application = Application.find(params[:application_id])

    # Get the github contribs and all the existings users and compute the intersection
    contribs = SessionHandler.instance.get_github_contributors(params[:repo]).map { |c| c[:login]}
    auth_users = User.all.map { |u| u.name }
    existing_contribs = contribs & auth_users
    existing_team_members_names = application.users.map { |u| u.name}

    # For all the existings users that are github contribs create a row in Contributor
    existing_contribs.each do |c|
      Contributor.create!({
        user_id: c,
        application_id: params[:application_id]
      }) unless c.in?(existing_team_members_names) # don't duplicate team members
    end
    redirect_to application_contributors_path(params[:application_id])
  end

  # DELETE /application/:application_id/contributors/:id
  def destroy
    app = Application.find(params[:application_id])
    render file: 'public/404.html' and return unless session[:user_id] == app.author
    contr = Contributor.find(params[:id])
    contr.destroy
    flash[:notice] = "Team member removed!"
    redirect_to application_contributors_path(app)
  end

  def composition_mail
    @application = Application.find(params[:application_id])
    @user = User.find(params[:user_id])
  end

  def composition_all
    @application = Application.find(params[:application_id])
  end

  def send_mail
    @application = Application.find(params[:application_id])
    @user = User.find(params[:user_id])
    ContributorsMailer.team_members_mail(@application, params[:sender], @user, params[:subject], params[:text]).deliver_now
    redirect_to application_contributors_path(@application.id)
  end

  def send_all
    @application = Application.find(params[:application_id])
    @application.users.each do |user|
      ContributorsMailer.team_members_mail(@application, params[:sender], user, params[:subject] + " (Broadcast)", params[:text]).deliver_now
    end
    redirect_to application_contributors_path(@application.id)
  end

end
