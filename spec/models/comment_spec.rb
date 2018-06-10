require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :body}

  describe 'default scope' do
    let(:user) { create(:user) }
    let(:comment_1) { create(:comment, commentable: create(:question, user: user), user: user) }
    let(:comment_2) { create(:comment, commentable: create(:question, user: user), user: user) }

    it 'orders by ascending created_at' do
      Comment.all.should eq [comment_1, comment_2]
    end
  end
end
