class AppDetailsController < ActionController::Base

  def stack_traces
    @reports ||= StackTrace.find_by(app: @current_app) if @current_app
  end
end
