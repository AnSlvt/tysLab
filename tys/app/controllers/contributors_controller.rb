class ContributorsController < ApplicationController

  before_action :logged_in?

  def index
    @application = Application.find(params[:application_id])
  end

  def destroy
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
