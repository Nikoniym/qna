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
    let(:answer_not_author) { create(:answer, question: question, user: other_user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :me, User }
    it { should be_able_to :manage, Subscription }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :changes, question, user: user }
    it { should_not be_able_to :changes, question_not_author, user: user }

    it { should be_able_to :changes, answer }
    it { should_not be_able_to :changes, answer_not_author, user: user }

    it { should be_able_to :destroy, attachment }
    it { should_not be_able_to :destroy, other_attachment }

    it { should be_able_to :set_best, answer_not_author }
    it { should_not be_able_to :set_best, create(:answer, question: question_not_author, user: user) }

    it { should be_able_to :new_comment, Question }
    it { should be_able_to :new_comment, Answer }


    it { should be_able_to :like, question_not_author }
    it { should be_able_to :like, answer_not_author }

    it { should_not be_able_to :like, question }
    it { should_not be_able_to :like, answer }

    it { should be_able_to :dislike, question_not_author }
    it { should be_able_to :dislike, answer_not_author }

    it { should_not be_able_to :dislike, question }
    it { should_not be_able_to :dislike, answer }

    it 'question cancel vote after like' do
      question_not_author.set_like!(user)
      should be_able_to :cancel_vote, question_not_author
    end

    it 'question cancel vote after dislike' do
      question_not_author.set_dislike!(user)
      should be_able_to :cancel_vote, question_not_author
    end

    it 'answer cancel vote after like' do
      answer_not_author.set_like!(user)
      should be_able_to :cancel_vote, answer_not_author
    end

    it 'answer cancel vote after dislike' do
      answer_not_author.set_dislike!(user)
      should be_able_to :cancel_vote, answer_not_author
    end

    it { should_not be_able_to :cancel_vote, question }
    it { should_not be_able_to :cancel_vote, answer }

    it { should_not be_able_to :cancel_vote, question_not_author }
    it { should_not be_able_to :cancel_vote, answer_not_author }
  end
end