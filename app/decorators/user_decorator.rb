class UserDecorator < Draper::Decorator
  delegate :email

  def completion_link
    h.mail_to email
  end

  def model
    h.content_tag(:span, 'User: ')
  end
end
