class Contributor < ActiveRecord::Base
  belongs_to :user
  belongs_to :application

  validates_associated :user
  validates_associated :application

  validates :user_id, presence: true, on: :create
  validates :application_id, presence: true, on: :create
end
