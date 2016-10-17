class FeedbacksController < ApplicationController

  before_action :logged_in?, only: [:destroy, :new, :update, :edit]


  def new
    @application = Application.find(params[:application_id])
    @user = User.find(session[:user_id])
  end

  def create
    # TODO: Validetes missing in model feedback.rb -> email control
    @feedback = Feedback.create!(feedback_params)
    app_id = @feedback.application_id
    user_id = Application.find(app_id).author
    if  session[:user_id]
      if @feedback.parent_id
        parent_feedback = Feedback.find(@feedback.parent_id)
        # parent_user = User.find(parent_feedback.user_name)
        FeedbackMailer.response_email(parent_feedback, @feedback).deliver_now if parent_feedback.email
      end
      redirect_to user_application_path(user_id, app_id)
    else
      redirect_to user_application_show_public_path(user_id, app_id)
    end
  end

  # Allow to delete feedback from db.
  def destroy
    @feedback = Feedback.destroy(params[:id])
    redirect_to user_application_path(session[:user_id], params[:application_id])
  end

  def show
  end

  #work with the view
  def edit
    @feedback = Feedback.find(params[:id])
    @user = User.find(session[:user_id])
  end

  #interact with the model
  def update
    @feedback = Feedback.find(params[:id])
    app_id = @feedback.application_id
    user_id = Application.find(app_id).author
    if  @feedback.update_attributes(update_params)
      redirect_to user_application_path(user_id, app_id)
    else
      redirect_to edit_application_feedback_path(user_id, app_id)
    end
  end

  private
  def feedback_params
    params.permit(:text, :application_id, :feedback_type, :email, :user_name, :parent_id)
  end

  private
  def update_params
    params.permit(:text, :feedback_type)
  end

end
