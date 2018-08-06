require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:answer) { answers.first }
  let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
  let(:comment) { comments.first }
  let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
  let!(:attachment) { attachments.last }

  describe 'GET /index' do
    it_behaves_like 'Api Authenticable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Response success'

      it_behaves_like 'Number of objects', 'answers', 2

      it_behaves_like 'Check the arguments object',
                      'answer',
                      %w(id body question_id created_at updated_at),
                      '0/'
    end
  end

  describe 'GET /show' do
    it_behaves_like 'Api Authenticable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Response success'

      it_behaves_like 'Number of objects', 'comments', 2, 'comments'
      it_behaves_like 'Number of objects', 'attachments', 2, 'attachments'


      it_behaves_like 'Check the arguments object',
                      'comment',
                      %w(id body created_at updated_at),
                      'comments/0/'

      %w(id url attachable_id attachable_type created_at updated_at).each do |attr|
        it "attachment object contains #{attr}" do
          if attr == 'url'
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("attachments/0/file/#{attr}")
          else
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    it_behaves_like 'Api Authenticable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      it 'returns 200 status code' do
        post_create_answer(:answer)
        expect(response).to be_success
      end

      it 'create answer with valid params' do
        expect { post_create_answer(:answer) }.to change(user.answers, :count).by(1)
      end

      it 'create answer with invalid params' do
        expect { post_create_answer(:invalid_answer) }.to_not change(user.answers, :count)
      end

      def post_create_answer(attribute)
        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(attribute),
                                                                   format: :json,
                                                                   access_token: access_token.token }
      end
    end
  end
end