class FeedbackController < ApplicationController
  def new
  end
  
  def create
    #Validetes missing in model feedback.rb
    @feedback = Feedback.create!(person_params)
  end
  
  private
  def feedback_params
    params.require(:feedback).permit(:text, :feedback_type, :email, :user_name)
  end
end
