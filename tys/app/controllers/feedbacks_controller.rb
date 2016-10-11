class FeedbacksController < ApplicationController

  before_action :logged_in?, only: :destroy

  def new
    @application = Application.find(params[:application_id])
  end

  def create
    # TODO: Validetes missing in model feedback.rb -> email control
    @feedback = Feedback.create!(feedback_params)
    app_id = @feedback.application_id
    user_id = Application.find(app_id).author
    if logged_in?
      #TODO Perchè non entra qui?
      redirect_to user_application(user_id, app_id)
    else
      redirect_to user_application_show_public_path(user_id, app_id)
    end
  end

  # Allow to delete feedback from db.
  def destroy
    # TODO: only auth user can delete feedbacks
  end

  def show
  end

  private
  def feedback_params
    params.permit(:text, :application_id, :feedback_type, :email, :user_name, :parent_id)
  end

end
