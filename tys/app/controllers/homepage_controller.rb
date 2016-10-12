class HomepageController < ApplicationController
  def index
  end

  def search
    @applications = Application.where("application_name like ?", "%#{params[:search_params]}%")
    @users = User.where("name like ?", "%#{params[:search_params]}%")
  end

  def search_user
    @users = User.where("name like ?", "%#{params[:search_params]}%")
  end
end
