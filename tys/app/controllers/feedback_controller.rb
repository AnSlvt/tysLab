class FeedbackController < ApplicationController
  def new
  end

  def create
    #Validetes missing in model feedback.rb -> email control
    @feedback = Feedback.create!(person_params)
  end

  #Allow to delete feedback from db.
  def delete
    Feedback.destroy(@feedback.id)
  end

  def show
  end
  
  private
  def feedback_params
    params.require(:feedback).permit(:text, :feedback_type, :email, :user_name)
  end
end
