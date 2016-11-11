class Issue < ActiveRecord::Base
  belongs_to :stack_trace
  validates_associated :stack_trace
  validates :github_repository, presence: true
  validates :github_number, presence: true
  validates :stack_trace_id, presence:true

  self.primary_key = "github_number"

  def github_issue
    SessionHandler.instance.get_repo_issue(self.github_repository, "#{self.github_number}")
  end

  def title
    #to pass a title for the creation on github
  end

  def body
    #to pass a body for the creation on github
  end

end
