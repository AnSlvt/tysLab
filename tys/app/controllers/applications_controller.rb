class ApplicationsController < ApplicationController

  before_action :logged_in?, except: :show_public
  before_action :is_allowed?, except: :show_public

  def show
    @application = Application.find_by(author: params[:user_id],
                                      id: params[:id])
    render file: "public/404.html" and return unless @application
    #@reports = StackTrace.where(app: @application.id) if @application
    @reports = @application.stack_traces
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.create!(create_params)
    @application.users << current_user
    flash[:notice] = "#{@application.application_name} was successfully created."
  end

  def index
  end

  def team_members
    @application = Application.find(params[:id])
  end

  def show_public
    @application = Application.find(params[:id])
    @feedbacks = @application.feedbacks
  end

  def destroy
    @application = Application.find_by(author: params[:user_id], id: params[:id])
    render file: "public/404.html" and return unless @application
    render file: "public/403.html" and return unless @application.author == current_user.name
    @application.destroy
    flash[:notice] = "#{@application.application_name} was successfully deleted."
    redirect_to user_applications_path
  end

  private
  def create_params
    params.require(:application).permit(:application_name, :author,
                                        :programming_language, :github_repository)
  end

  def is_allowed?
    unless params[:user_id] == session[:user_id] || Contributor.find_by(user_id: session[:user_id])
      render file: "public/404.html" and return
    end
  end

end
