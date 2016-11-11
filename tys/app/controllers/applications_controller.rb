class ApplicationsController < ApplicationController

  before_action :logged_in?, except: :show_public

  # GET /users/:user_id/applications/:id
  def show
    @application = Application.find_by(author: params[:user_id], id: params[:id])
    render file: "public/404.html", status: 404 and return unless @application
    render file: 'public/403.html', status: 403 and return unless current_user.in?(@application.users)

    # Stack traces
    raw_reports = @application.stack_traces
    @reports = StackTrace.st_order_by(raw_reports, params[:sort_mode])

    # Additional info
    @feedbacks = Feedback.where(application_id: params[:id])
    @github_param = @application.github_repository.sub('/', '_')
    @token = @application.authorization_token
  end

  # GET /users/:user_id/applications/new
  def new
    @application = Application.new
    logger.info "SESSION = #{session[:token]}"
    logger.info "INSTANCE = #{SessionHandler.retrieve_instance(session[:token])}"
    repos = SessionHandler.retrieve_instance(session[:token]).get_repos(current_user)
    @repos = repos.map do |r|
      r[:full_name] if r[:owner][:login] == current_user.name
    end
    @repos.delete nil
    @repos.unshift nil
    @token = SecureRandom.urlsafe_base64(nil, false)
  end

  # POST /users/:user_id/applications
  def create
    begin
      @application = Application.create!(create_params)
    rescue ActiveRecord::RecordInvalid => invalid
      render file: 'public/500.html', status: 500 and return
    end
    @application.users << current_user
    redirect_to user_application_path(current_user, @application), notice: "#{@application.application_name} was successfully created."
  end

  # GET /users/:user_id/applications
  def index
    render file: 'public/403.html', status: 403 unless current_user.name == params[:user_id]
    @pending = Invitation.where(leader_name: current_user)
    @invitations = Invitation.where(target_name: current_user)
    @applications = Application.where(author: current_user)
  end

  # GET /users/:user_id/applications/:application_id/show_public
  def show_public
    @application = Application.find_by(author: params[:user_id], id: params[:application_id])
    render file: 'public/404.html', status: 404 and return unless @application
    @feedbacks = @application.feedbacks
  end

  # DELETE /users/:user_id/applications/:id
  def destroy
    @application = Application.find_by(id: params[:id])
    render file: "public/404.html", status: 404 and return unless @application
    render file: "public/403.html", status: 403 and return unless @application.author == session[:user_id]
    @application.destroy
    flash[:notice] = "#{@application.application_name} was successfully deleted."
    redirect_to user_applications_path
  end

  private
  def create_params
    params.require(:application).permit(:application_name, :author,
                  :programming_language, :github_repository, :authorization_token)
  end
end
