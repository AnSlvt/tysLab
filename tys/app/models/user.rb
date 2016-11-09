class User < ActiveRecord::Base
  self.primary_key = "name"
  has_many :contributors
  has_many :applications, through: :contributors
  has_many :invitations

  def get_github_image
    SessionHandler.instance.get_github_user(self.name).avatar_url
  end
#  validates :email
end
