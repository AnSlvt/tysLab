class StackTraceDetailsController < ActionController::Base

  def new
    StackTrace.new
  end

  def show_details

    # Get the current stack trace
    @report = StackTrace.find(params[:id])

    # Get the list of devices that generated the same exception in the current app
    similar = StackTrace.where(app: @report.application, type: @report.type) if @report
    @devices = similar.collect { |crash| crash.device }.uniq

    # Get the times of the first and last occurrence of this exception
    time_ordered = similar.sort { |a, b| a.time <=> b.time }
    @most_recent = time_ordered.last
    @first_time = time_ordered.first
  end
end
