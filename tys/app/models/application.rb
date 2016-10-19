class Application < ActiveRecord::Base
  belongs_to :user, -> { where(author: user.id) }
  has_many :contributors, dependent: :destroy
  has_many :users, through: :contributors
  has_many :feedbacks, dependent: :destroy
  has_many :stack_traces, dependent: :destroy
end
