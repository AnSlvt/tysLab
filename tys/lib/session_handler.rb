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

  def create_stack_trace_issue(repo, title, body)
    @@oct_client.create_issue(repo, title, body, {:labels => 'bug'})
  end

  private_class_method :new
end
