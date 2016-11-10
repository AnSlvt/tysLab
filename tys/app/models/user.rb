class User < ActiveRecord::Base
  self.primary_key = "name"
  has_many :contributors
  has_many :applications, through: :contributors
  has_many :invitations

  validates :name, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, presence: true

  def get_github_image
    SessionHandler.instance.get_github_user(self.name).avatar_url
  end
end
