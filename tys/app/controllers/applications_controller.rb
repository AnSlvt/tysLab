class ApplicationsController < ApplicationController

  before_action :logged_in?, except: :show_public
  before_action :is_allowed?, except: :show_public

  # GET /users/:user_id/applications/:id
  def show
    @application = Application.find_by(author: params[:user_id], id: params[:id])
    render file: "public/404.html", status: 404 and return unless @application
    # Stack traces
    raw_reports = @application.stack_traces
    if (!params[:sort_mode] || params[:sort_mode] == '1')
      # grouped by app version number
      out = []
      raw_reports.group_by(&:application_version).each do |ver, stacks|
        out += stacks.sort { |a, b| a.crash_time <=> b.crash_time }
      end
      @reports = out.reverse
    elsif (params[:sort_mode] == '2')
      # alphabetical order
      @reports = raw_reports.sort_by { |ex| [ex.error_type, ex.stack_trace_message] }
    elsif (params[:sort_mode] == '3')
      # frequency order
      out = []
      dic = {}
      iter = []
      raw_reports.group_by(&:error_type).each do |type, stacks|
        dic[type] = stacks
        iter << [type, stacks.length]
      end
      iter.sort_by { |row| row[1] }.reverse.each do |tuple|
        out += dic[tuple[0]]
      end
      @reports = out
    else
      # fixed status order
      @reports = raw_reports.sort_by { |ex| [ex.fixed, ex.crash_time] }
    end

    # Additional info
    @feedbacks = Feedback.where(application_id: params[:id])
    @github_param = @application.github_repository.sub('/', '_')
  end

  # GET /users/:user_id/applications/new
  def new
    @application = Application.new
    repos = SessionHandler.instance.get_repos(current_user)
    @repos = repos.map do |r|
      r[:full_name] if r[:owner][:login] == current_user.name
    end
    @repos.delete nil
    @repos.unshift nil
  end

  # POST /users/:user_id/applications
  def create
    @application = Application.create!(create_params)
    @application.users << current_user
    flash[:notice] = "#{@application.application_name} was successfully created."
  end

  # GET /users/:user_id/applications
  def index
    @pending = Invitation.where(leader_name: current_user)
    @invitations = Invitation.where(target_name: current_user)
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
    render file: "public/404.html" and return unless @application
    render file: "public/403.html" and return unless @application.author == session[:user_id]
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
