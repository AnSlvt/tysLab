class FeedbackResponse < ActiveRecord::Base
  has_one :feedback, -> { where(response_id: Feedback.id) }
  has_one :feedback, -> { where(target_id: Feedback.id) }
  belongs_to :user
end
