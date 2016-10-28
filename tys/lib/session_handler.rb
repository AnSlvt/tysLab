require 'singleton'

class SessionHandler

  @@session = SessionHandler.new

  def self.instance(client=nil)
    @@oct_client ||= client
    @@session
  end

  def get_repos(user)
    @@oct_client.repos(user)
  end

  def get_github_contributors(repo)
    repo = repo.sub('_', '/')
    @@oct_client.collabs(repo)
  end

  def get_repo_issues(application)
    @@oct_client.list_issues(application.github_repository)
  end

  def create_repo_issues(application, stack_trace)
    @@oct_client.create_issue(application.github_repository, stack_trace.stack_trace_message, stack_trace_text)
  end


  private_class_method :new
end
