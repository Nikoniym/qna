shared_examples_for 'commentable' do
  describe 'GET #new_comment' do
    before do
      resource_id = "#{resource.class.name.downcase}_id".to_sym
      get :new_comment, params: { resource_id => resource }, xhr: true
    end

    it 'assigns a new Comment to @comment' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it 'renders new_comment template' do
      expect(response).to render_template :new_comment
    end
  end
end