require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:ratings) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
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

  describe '.find_for_ouath' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_ouath(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_ouath(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_ouath(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_ouath(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_ouath(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'user@gmail.com' }) }

        it 'create new user' do
          expect { User.find_for_ouath(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_ouath(auth)).to be_a (User)
        end

        it 'fills user email' do
          user = User.find_for_ouath(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'create authorization for user' do
          user = User.find_for_ouath(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'create authorization with provider and uid' do
          authorization = User.find_for_ouath(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end