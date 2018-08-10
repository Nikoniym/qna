class NewAnswerMailer < ApplicationMailer
  def digest(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email
  end
end
