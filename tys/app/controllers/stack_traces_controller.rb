class StackTracesController < ApplicationController

  before_action :logged_in?, except: :create

  def new
    StackTrace.new
  end

  def create
    @application = Application.find_by(authorization_token: request.headers["Authorization"])
    render file: 'public/403.html', status: 403 and return unless @application
    prm = JSON.parse(request.body.read)
    prm = prm["Content"]
    begin
      StackTrace.create!(application_id: @application.id,
                        stack_trace_text: prm["StackTrace"],
                        stack_trace_message: prm["Message"],
                        application_version: prm["AppVersion"],
                        fixed: false,
                        crash_time: prm["CrashDateTime"],
                        error_type: prm["Type"],
                        device: prm["Device"])
    rescue RecordInvalid
      render file: 'public/500.html', status: 500 and return
    end
    render nothing: true
  end

  def show

    app = Application.find_by(author: params[:user_id], id: params[:application_id])
    render file: 'public/404.html', status: 404 and return unless app
    render file: 'public/403.html', status: 403 and return unless current_user.in?(app.users)

    # Get the current stack trace
    @report = StackTrace.find_by(id: params[:id])
    render file: 'public/404.html', status: 404 and return unless @report

    # Get the list of devices that generated the same exception in the current app
    similar = StackTrace.where(application_id: @report.application, error_type: @report.error_type) if @report
    devs = []
    similar.group_by(&:device).each do |device, stacks|
      devs << [device, stacks.length]
    end
    @devices = devs.sort { |a, b| a[1] <=> b[1] }.reverse

    # Get the times of the first and last occurrence of this exception
    time_ordered = similar.sort { |a, b| a.crash_time <=> b.crash_time }
    @most_recent = time_ordered.last
    @first_time = time_ordered.first
  end

  def update
    @stack_trace = StackTrace.find_by(application_id: params[:application_id], id: params[:id])
    render file: 'public/404.html', status: 404 and return unless @stack_trace
    render file: 'public/403.html', status: 403 and return unless current_user.name == params[:user_id]
    v = !@stack_trace.fixed
    @stack_trace.update({ fixed: v })
    redirect_to user_application_path(params[:user_id], params[:application_id])
  end
end
