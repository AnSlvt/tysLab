class ContributorsMailer < ApplicationMailer
  default from: 'traceyourstack@gmail.com'

  def team_members_mail(application, sender, receiver, subject, text)
    @application = application
    @sender = User.find(sender)
    @receiver = User.find(receiver)
    @subject = subject
    @text = text
    mail(to: @receiver.email, subject: @subject)
  end

  def invitation_accepted(contr_id)
    @contributor = Contributor.find(contr_id)
    @application = Application.find(@contributor.application_id)
    email = User.find(@application.author).email
    mail(to: email, subject: "Invitation accepted")
  end

end
