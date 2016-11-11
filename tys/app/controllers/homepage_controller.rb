class HomepageController < ApplicationController

  # GET /
  def index
    reset_session
  end

  # GET /search_results
  def search
    @applications = Application.where("application_name like ?", "%#{params[:search_params]}%")
    @users = User.where("name like ?", "%#{params[:search_params]}%")
  end

  # GET /user_search
  def search_user
    @users = User.where("name like ?", "%#{params[:search_params]}%")
  end
end
