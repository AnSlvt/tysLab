class Feedback < ActiveRecord::Base
  belongs_to :application
  validates :email, :allow_nil
end
