class Feedback < ActiveRecord::Base
  belongs_to :application
  validates_associated :application
  validates :text, :feedback_type, :user_name, presence: true, on: :create
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, allow_nil: true
end
