class ContributorsController < ApplicationController

  before_action :logged_in?

  def index
    @application = Application.find(params[:application_id])
  end

  # GET /users/:user_id/applications/:application_id/invitations/:invitation_id/accept/:token
  def create
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

end