class ApplicationsController < ApplicationController
  #shows the application (identified by its id) details in a dedicated haml page, containing details and its own stacktraces
  def show
    @application = Application.find(params[:id])
  end

  #creates a new application, which author is che current user (redirection to a form that execute a POST to invoke the create method)
  def new
    @application = @current_user.applications.build #does it render the creation form?
  end
  #alternative
  #def new
    ##default: render 'new' template
  #end

  #after "new" action, the real creation
  def create
    @current_user.applications << @current_user.applications.build(params[:application]) #not sure if it's possible
  end
  #alternative
  #def create
    #@application = Application.create!(params[:application])
    #flash[:notice] = "#{@application.application_name} was successfully created."
  #end

  #IMPORTANT: check asap if new and create implementation is correct! (must use nested resources, applications can be created only by a user)
  #TODO: (see pg.158) insert presence controls for current_user
end
