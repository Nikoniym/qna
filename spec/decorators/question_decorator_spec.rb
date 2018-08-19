require 'rails_helper'

RSpec.describe QuestionDecorator do
  include Rails.application.routes.url_helpers

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:decorator) { QuestionDecorator.new(question) }
  let(:path) { question_path(question) }
  let(:text) { question.title }
  let(:span) { 'Question: ' }

  it_behaves_like 'Search response'
end
