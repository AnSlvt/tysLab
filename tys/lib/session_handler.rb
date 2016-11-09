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

  def get_repo_issue(repo, number)
    @@oct_client.issue(repo, number)
  end

  def get_repo_labels_for_issue(repo, number)
    @@oct_client.labels_for_issue(repo, number)
  end

  def add_label_to_a_stack_trace_issue(repo, number, label_name)
    @@oct_client.add_labels_to_an_issue(repo, number, label_name)
  end

  def reopen_stack_trace_issue(repo, number)
    @@oct_client.reopen_issue(repo, number)
  end

  def close_stack_trace_issue(repo, number)
    @@oct_client.close_issue(repo, number)
  end

  def get_github_user(username)
    @@oct_client.user(username)
  end

  private_class_method :new
end
