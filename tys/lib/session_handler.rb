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

  private_class_method :new
end
