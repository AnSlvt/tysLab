class User < ActiveRecord::Base
  self.primary_key = "name"
  has_many :contributors
  has_many :applications, through: :contributors
  has_many :invitations

#  validates :email

  # When a team leader look for another user, we use this function
  def user_research
    self.user.each do |user|
      user.where.not(name: self.id)
    end
  end
end
