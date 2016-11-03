class Issue < ActiveRecord::Base
  belongs_to :stack_trace

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
