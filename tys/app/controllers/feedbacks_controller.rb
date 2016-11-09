class FeedbacksController < ApplicationController

  before_action :logged_in?, only: [:destroy, :new, :update, :edit]

  # GET /application/:application_id/feedbacks/:parent_id
  def new
    @application = Application.find_by(id: params[:application_id])
    @target = Feedback.find_by(id: params[:parent_id])
    render file: 'public/404.html', status: 404 and return unless @application
    render file: 'public/404.html', status: 404 and return unless @target
    @user = User.find(session[:user_id])
    render file: 'public/403.html', status: 403 and return unless @user.in?(@application.users)
  end

  # POST /application/:application_id/feedbacks
  def create
    # TODO: Validetes missing in model feedback.rb -> email control
    @feedback = Feedback.create!(feedback_params)
    app_id = @feedback.application_id
    user_id = Application.find(app_id).author
    if  session[:user_id]
      if @feedback.parent_id
        parent_feedback = Feedback.find_by(id: @feedback.parent_id)
        render file: 'public/404.html', status: 404 and return unless parent_feedback
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
    @application = Application.find(params[:application_id])
    @feedback = Feedback.find_by(application_id: params[:application_id], id: params[:id])
    render file: 'public/404.html', status: 404 and return unless @feedback
    render file: 'public/403.html', status: 403 and return unless @feedback.user_name == current_user.name || @application.author == current_user.name
    @feedback.destroy
    redirect_to user_application_path(session[:user_id], params[:application_id])
  end

  #work with the view
  def edit
    @feedback = Feedback.find_by(application_id: params[:application_id], id: params[:id])
    render file: 'public/404.html', status: 404 and return unless @feedback
    render file: 'public/403.html', status: 403 and return unless @feedback.user_name == current_user.name
    @user = User.find(session[:user_id])
  end

  #interact with the model
  def update
    @feedback = Feedback.find_by(application_id: params[:application_id], id: params[:id])
    render file: 'public/404.html', status: 404 and return unless @feedback
    render file: 'public/403.html', status: 403 and return unless @feedback.user_name == current_user.name
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
