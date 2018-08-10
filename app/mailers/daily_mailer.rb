class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions

    mail to: user.email
  end
end
