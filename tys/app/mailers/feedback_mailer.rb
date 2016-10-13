class FeedbackMailer < ApplicationMailer
  default from: 'traceyourstack@gmail.com'
  layout "feedback_mailer"

  def response_email(user, response_feedback)
    @user = user
    @response_feedback = response_feedback
    mail(to: @user.email, subject: 'Response Mail', template_path: "feedback_mailer", template_name: "response_email")
  end

end
