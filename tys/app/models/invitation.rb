class Invitation < ActiveRecord::Base
  has_one :application
  has_one :user
  belongs_to :user, -> { where(leader_name: application.author) }
end
