class User < ActiveRecord::Base
  self.primary_key = "name"
  has_many :contributors
  has_many :applications, through: :contributors
  has_many :invitations

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, presence: true
end
