class Application < ActiveRecord::Base
  belongs_to :user, -> { where(author: user.id) }
  has_many :users, through: :contributors
  has_many :feedbacks
  has_many :stack_traces
end
