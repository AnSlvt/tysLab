class StackTracesController < ApplicationController

  before_action :logged_in?

  def new
    StackTrace.new
  end

  # TODO: Creation and create_params
  def create
    @application = Application.find_by(author: params[:user_id],
                                      auth_token: params[:auth_token])
    render file: "public/404.html" and return if !@application
    StackTrace.create!(create_params)
  end

  def show

    # Get the current stack trace
    @report = StackTrace.find(params[:id])

    # Get the list of devices that generated the same exception in the current app
    similar = StackTrace.where(app: @report.application, type: @report.error_type) if @report
    @devices = similar.collect { |crash| crash.device }.uniq

    # Get the times of the first and last occurrence of this exception
    time_ordered = similar.sort { |a, b| a.crash_time <=> b.crash_time }
    @most_recent = time_ordered.last
    @first_time = time_ordered.first
  end

  def update
    stack_trace = StackTrace.find_by(application_id: params[:application_id], id: params[:id])
    render file: 'public/404.html', status: 404 and return unless stack_trace
    render file: 'public/403.html', status: 403 and return unless current_user.name == params[:user_id]
    v = !stack_trace.fixed
    stack_trace.update({ fixed: v })
    redirect_to user_application_path(params[:user_id], params[:application_id])
  end

  private
  def create_params
    params.require(:stack_trace).permit()
  end
end
