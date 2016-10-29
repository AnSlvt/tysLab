class FeedbackMailer < ApplicationMailer
  default from: 'traceyourstack@gmail.com'

  def response_email(parent_feedback, response_feedback)
    @parent_feedback = parent_feedback
    @response_feedback = response_feedback
    mail(to: @parent_feedback.email, subject: 'Response Mail', template_path: "feedback_mailer", template_name: "response_email")
  end

end
