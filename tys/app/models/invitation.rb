class Invitation < ActiveRecord::Base
  has_one :application
  has_one :user
  belongs_to :user, -> { where(leader_name: app.author) }

  validates_associated :user
  validates_associated :application
  validates :invite_token, presence: true
end
