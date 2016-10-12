class InvitationsController < ApplicationController
  def create
    @application = Application.find(params[:application_id])
    flash[:notice] = "#{params[:user_id]} invited to #{@application.application_name}"
    render nothing: true
  end

  def destroy
  end
end
