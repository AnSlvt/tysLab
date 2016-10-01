class AppDetailsController < ActionController::Base

  def load_details
    @app = Application.find(params[:id])
    @reports ||= StackTrace.where(app: @app.id) if @app
  end
end
