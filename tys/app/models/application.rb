class Application < ActiveRecord::Base
  #attr_accessible :application_name, :author, :programming_language, :github_repository
  belongs_to :user, -> { where(author: user.id) }
  has_many :users, through: :contributors
  has_many :feedbacks
  has_many :stack_traces

end
