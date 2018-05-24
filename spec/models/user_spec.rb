require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'test method #author_of?' do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:question) { create(:question, user: user_1) }

    it 'true if the user is the author of the question' do
      expect(user_1).to be_author_of(question)
    end

    it 'false if the user is not the author of the question' do
      expect(user_2).to_not be_author_of(question)
    end
  end
end