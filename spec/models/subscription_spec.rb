require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user ) }
  let(:other_user) { create(:user) }

  it { should belong_to :question }
  it { should belong_to :user }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user ) }

  it 'unique question_id and user_id return true' do
    expect(Subscription.new(user: other_user, question: question).valid?).to eq true
  end

  it 'unique question_id and user_id return false' do
    expect(Subscription.new(user: user, question: question).valid?).to eq false
  end
end
