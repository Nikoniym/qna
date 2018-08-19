require 'rails_helper'

RSpec.describe AnswerDecorator do
  include Rails.application.routes.url_helpers

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:decorator) { AnswerDecorator.new(answer) }
  let(:path) { question_path(question) }
  let(:text) { answer.body }
  let(:span) { 'Answer: ' }

  it_behaves_like 'Search response'
end
