class User < ActiveRecord::Base
  self.primary_key = "name"
  has_many :contributors
  has_many :applications, through: :contributors
  has_many :invitations

#  validates :email
end
