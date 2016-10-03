class User < ActiveRecord::Base
  has_many :applications, through: :contributors
  has_many :invitations

  def created_applications
    self.applications.each do |application|
      application.where(author: self.id)
    end
  end

#When a team leader look for another user, we use this function
 def user_research
   self.user.each do |user|
     user.where.not(name: self.id)
   end
 end

end
