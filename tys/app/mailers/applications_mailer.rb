class ApplicationsMailer < ApplicationMailer
  default from: 'traceyourstack@gmail.com'
  layout "applications_mailer"

  def team_members_mail(application, sender, receiver, subject, text)
    @application = application
    @sender = User.find(sender)
    @receiver = User.find(receiver)
    @subject = subject
    @text = text
    mail(to: @receiver.email, subject: @subject)

  end

end
