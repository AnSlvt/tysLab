class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    #@reports = StackTrace.where(app: @application.id) if @application
    @reports = @application.stack_traces
  end

  def new
    @application = Application.new
    logger.info "Method new for application called #{@application}"
  end

  def create
    @application = Application.create!(create_params)
    @application.users << current_user
    flash[:notice] = "#{@application.application_name} was successfully created."
  end

  private
  def create_params
    params.require(:application).permit(:application_name, :author,
                                        :programming_language, :github_repository)
  end

  #TODO: (see pg.158) insert presence controls for current_user
end
