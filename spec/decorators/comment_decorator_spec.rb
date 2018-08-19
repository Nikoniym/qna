require 'rails_helper'

RSpec.describe CommentDecorator do
  include Rails.application.routes.url_helpers

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:comment_question) { create(:comment, commentable: question, user: user, body: 'Question comment') }
  let(:comment_answer) { create(:comment, commentable: question, user: user, body: 'Answer comment') }
  let(:span) { 'Comment: ' }

  describe 'comment from question' do
    let(:decorator) { CommentDecorator.new(comment_question) }
    let(:path) { question_path(comment_question.commentable_id) }
    let(:text) { comment_question.body }

    it_behaves_like 'Search response'
  end

  describe 'comment from answer' do
    let(:decorator) { CommentDecorator.new(comment_answer) }
    let(:path) { question_path(comment_answer.commentable.id) }
    let(:text) { comment_answer.body }

    it_behaves_like 'Search response'
  end
end
