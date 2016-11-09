class Contributor < ActiveRecord::Base
  belongs_to :user
  belongs_to :application

  validates_associated :user
  validates_associated :application
end
