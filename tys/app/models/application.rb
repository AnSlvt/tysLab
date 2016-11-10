class Application < ActiveRecord::Base
  belongs_to :user, -> { where(author: user.id) }
  has_many :contributors, dependent: :destroy
  has_many :users, through: :contributors
  has_many :feedbacks, dependent: :destroy
  has_many :stack_traces, dependent: :destroy

  validates_associated :user
  validates_inclusion_of :programming_language, in: ['C#', 'Java', 'Objective-C']
  validates :application_name, :programming_language, presence: true, on: :create
end
