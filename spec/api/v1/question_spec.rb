require 'rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:questions) { create_list(:question, 2, user: user) }
  let(:question) { questions.first }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
  let(:comment) { comments.first }
  let!(:attachments) { create_list(:attachment, 2, attachable: question) }
  let!(:attachment) { attachments.last }

  describe 'GET /index' do
    it_behaves_like 'Api Authenticable' do
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Response success'

      it_behaves_like 'Number of objects', 'questions', 2

      it_behaves_like 'Check the arguments object',
                      'question',
                      %w(id title body user_id created_at updated_at),
                      '0/'


      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it_behaves_like 'Number of objects', 'answers', 1, '0/answers'

        it_behaves_like 'Check the arguments object',
                        'answer',
                        %w(id body user_id question_id created_at updated_at),
                        '0/answers/0/'
      end
    end
  end

  describe 'GET /show' do
    it_behaves_like 'Api Authenticable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Response success'

      it_behaves_like 'Number of objects', 'comments', 2, 'comments'
      it_behaves_like 'Number of objects', 'attachments', 2, 'attachments'

      it_behaves_like 'Check the arguments object',
                      'comment',
                      %w(id body commentable_id commentable_type created_at updated_at),
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
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      it 'returns 200 status code' do
        post_create_question(:question)
        expect(response).to be_success
      end

      it 'create question with valid params' do
        expect { post_create_question(:question) }.to change(user.questions, :count).by(1)
      end

      it 'create question with invalid params' do
        expect { post_create_question(:invalid_question) }.to_not change(user.questions, :count)

      end

      def post_create_question(attribute)
        post "/api/v1/questions", params: { question: attributes_for(attribute),
                                            format: :json,
                                            access_token: access_token.token }
      end
    end
  end
end