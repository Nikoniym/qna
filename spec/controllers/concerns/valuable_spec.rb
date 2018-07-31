shared_examples_for "valuable" do
  describe '#like' do
   it 'not keep like to database for your resource' do
     expect { put :like, params: { id: resource }, format: :json }.to_not change(resource.ratings, :count)
   end

   it 'save to database for not your resource' do
     expect { put :like, params: { id: else_resource }, format: :json }.to change(else_resource.ratings, :count).by(1)
   end

   it 'double like' do
     put :like, params: { id: else_resource }, format: :json
     expect(put :like, params: { id: else_resource }, format: :json).to have_http_status(:unprocessable_entity)
   end
  end

  describe '#dislike' do
    it 'not keep dislike to database for your resource' do
      expect { put :dislike, params: { id: resource }, format: :json }.to_not change(resource.ratings, :count)
    end

    it 'save to database for not your resource' do
      expect { put :dislike, params: { id: else_resource }, format: :json }.to change(else_resource.ratings, :count).by(1)
    end

    it 'double dislike' do
      put :dislike, params: { id: else_resource }, format: :json
      expect(put :dislike, params: { id: else_resource }, format: :json).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#cancel_vote' do
    it 'not change to database for your resource' do
      expect { put :cancel_vote, params: { id: resource }, format: :json }.to_not change(resource.ratings, :count)
    end

    it 'change to database for not your resource' do
      put :dislike, params: { id: else_resource }, format: :json
      expect { put :cancel_vote, params: { id: else_resource }, format: :json }.to change(else_resource.ratings, :count).by(-1)
    end

    it 'nothing to cancel' do
      expect(put :cancel_vote, params: { id: else_resource }, format: :json).to have_http_status(:forbidden)
    end
  end

  it 'dislike after like' do
    put :like, params: { id: else_resource }, format: :json
    expect { put :dislike, params: { id: else_resource }, format: :json }.to_not change(else_resource.ratings, :count)
  end

  it 'like after dislike' do
    put :dislike, params: { id: else_resource }, format: :json
    expect { put :like, params: { id: else_resource }, format: :json }.to_not change(else_resource.ratings, :count)
  end
end