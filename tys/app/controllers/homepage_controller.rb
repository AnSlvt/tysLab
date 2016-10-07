class HomepageController < ApplicationController
  def index
  end

  def search
    @applications = Application.where("application_name like ?", "%#{params[:search_params]}%")
    @user = User.find_by(name: params[:search_params])
  end
end
