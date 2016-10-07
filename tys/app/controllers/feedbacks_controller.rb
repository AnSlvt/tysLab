class FeedbacksController < ApplicationController

  before_action :logged_in?, only: :destroy

  def new
  end

  def create
    # TODO: Validetes missing in model feedback.rb -> email control
    @feedback = Feedback.create!(feedback_params)
    app_id = @feedback.application_id
    user_id = Application.find(app_id).author
    redirect_to user_application_show_public_path(user_id, app_id) unless session[:user_id]
  end

  # Allow to delete feedback from db.
  def destroy
    # TODO: only auth user can delete feedbacks
  end

  def show
  end

  private
  def feedback_params
    params.permit(:text, :application_id, :feedback_type, :email, :user_name)
  end


end
