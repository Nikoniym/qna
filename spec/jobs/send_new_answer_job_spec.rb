require 'rails_helper'

RSpec.describe SendNewAnswerJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'sends an email with answer to subscribers' do
    question.subscriptions.each do |sub|
      expect(NewAnswerMailer).to receive(:digest).with(sub.user, answer).and_call_original
    end

    SendNewAnswerJob.perform_now(answer)
  end
end
