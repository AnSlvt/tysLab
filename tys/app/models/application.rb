class Application < ActiveRecord::Base
  belongs_to :user, -> { where(id: self.author) }
  has_many :users, through: :contributors
  has_many :feedbacks
  has_many :stack_traces
end
