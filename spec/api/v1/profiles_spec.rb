require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let!(:users) { create_list(:user, 3) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'Get /me' do
    it_behaves_like 'Api Authenticable' do
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Response success'

      it_behaves_like 'Check the arguments object',
                      'me',
                      %w(id email created_at updated_at admin)

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #index' do
    it_behaves_like 'Api Authenticable' do
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Response success'

      it 'contains users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'does not have me user' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end
  end
end