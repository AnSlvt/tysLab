class SubscribeMailer < ApplicationMailer
  default from: "traceyourstack@gmail.com"


  def subscribe_mail(source, target_mail, link)
    @source = source
    @link = link
    mail to: target_mail, subject: "#{source} invited you to join TraceYourStack"
  end
end
