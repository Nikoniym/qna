require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }
  it { should have_many(:ratings).dependent(:destroy) }
  it { should accept_nested_attributes_for(:ratings) }

  it { should validate_presence_of :body }

  describe 'test method #set_best! with order' do
    let(:user) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, best: true, user: user, question: question)}

    let(:answers) { create_list(:answer, 2, user: user, question: question) }

    it 'set new best answer' do
      answers.first.set_best!
      expect(answers.first.best).to eq true
    end

    it 'change current best answer to false' do
      answer
      answers.first.set_best!
      answer.reload
      expect(answer.best).to eq false
    end

    it 'order best first' do
      answers
      answer
      expect(Answer.first.best).to eq true
    end
  end
end
