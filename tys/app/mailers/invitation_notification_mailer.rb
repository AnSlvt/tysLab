class InvitationNotificationMailer < ApplicationMailer
  layout 'invitation_notification_mailer'
  default from: "traceyourstack@gmail.com"

  def invitation_mail(source, target, app, link)
    @source = source
    @target = target
    @app = app
    @link = link
    mail(to: target.email, subject: "#{source} invited you to join his app #{app}")
  end
end
