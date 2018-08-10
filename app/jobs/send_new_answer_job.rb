class SendNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    subscriptions = answer.question.subscriptions

    if subscriptions.present?
      subscriptions.find_each do |sub|
        NewAnswerMailer.digest(sub.user, answer).deliver_later
      end
    end
  end
end
