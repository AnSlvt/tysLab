class StackTraceDetailsController < ActionController::Base

  def stack_trace_details

    # Get the list of devices that generated the same exception in the current app
    similar = StackTrace.find_by(app: @current_app, type: @report.type) if @current_app && report
    temp = []
    grouped = similar.group_by{|device|}
    grouped.values.each do |group|
      temp << group
    @devices = temp

    # Get the times of the first and last occurrence of this exception
    time_ordered = similar.sort { |a,b| a.time <=> b.time }
    @most_recent = time_ordered.last
    @first_time = time_ordered.first
  end
end
