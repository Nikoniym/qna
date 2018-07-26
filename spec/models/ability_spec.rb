require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:question_not_author) { create(:question, user: other_user) }
    let(:attachment) { create(:attachment, attachable: question) }
    let(:other_attachment) { create(:attachment, attachable: question_not_author) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :changes, question, user: user }
    it { should_not be_able_to :changes, question_not_author, user: user }

    it { should be_able_to :changes, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :changes, create(:answer, question: question, user: other_user), user: user }

    it { should be_able_to :destroy, attachment }
    it { should_not be_able_to :destroy, other_attachment }

    it { should be_able_to :set_best, create(:answer, question: question, user: other_user) }
    it { should_not be_able_to :set_best, create(:answer, question: question_not_author, user: user) }

    it { should be_able_to :new_comment, Question }
    it { should be_able_to :new_comment, Answer }

    it { should be_able_to :vote, question_not_author }
    it { should be_able_to :vote, create(:answer, question: question, user: other_user) }

    it { should_not be_able_to :vote, question }
    it { should_not be_able_to :vote, create(:answer, question: question, user: user) }
  end
end