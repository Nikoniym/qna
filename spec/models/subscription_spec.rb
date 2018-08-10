require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:user) { create(:user) }
  # subject { Subscription.create(user: user, question: create(:question, user: user)) }

  it { should belong_to :question }
  it { should belong_to :user }

  # it { should validate_uniqueness_of(:user).scoped_to(:question) }
end
