class User < ActiveRecord::Base
  has_many :applications, through: :contributors
  has_many :invitations

  #All the applications created by the current user (do we need this?)
  def created_applications
    self.applications.each do |application|
      application.where(author: self.id)
    end
  end

end
