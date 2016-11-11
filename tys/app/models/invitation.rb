class Invitation < ActiveRecord::Base
  has_one :application
  has_one :user
  belongs_to :user, -> { where(leader_name: app.author) }

  validates_associated :user
  validates_associated :application
  validates :invite_token, presence: true
  validates :leader_name, presence: true
  validates :target_name, presence: true
  validates :application_id, presence: true 
end
