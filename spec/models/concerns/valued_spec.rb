shared_examples_for 'valued' do

  it { should have_one(:rating).dependent(:destroy) }

  it { is_expected.to callback(:create_rating).after(:create) }

  let (:user) { create(:user) }

  it '#number' do
    expect(resource.number).to eq 0
  end

  describe 'Set rating' do
    before do
      resource.number
      resource.reload
    end

    it '#set_like?(user) false' do
      expect(resource.set_like?(user)).to eq false
    end

    it '#set_like?(user) true' do
      resource.set_like!(user)
      expect(resource.set_like?(user)).to eq true
    end

    it '#set_dislike?(user) false' do
      expect(resource.set_dislike?(user)).to eq false
    end

    it '#set_dislike?(user) true' do
      resource.set_dislike!(user)
      expect(resource.set_dislike?(user)).to eq true
    end

    it '#set_like!(user)' do
      resource.set_like!(user)
      expect(resource.number).to eq 1
    end

    it '#set_dislike!(user)' do
      resource.set_dislike!(user)
      expect(resource.number).to eq -1
    end

    it '#delete_vote!(user) for like' do
      resource.set_like!(user)
      resource.delete_vote!(user)
      expect(resource.number).to eq 0
    end

    it '#delete_vote!(user) for dislike' do
      resource.set_dislike!(user)
      resource.delete_vote!(user)
      expect(resource.number).to eq 0
    end
  end
end
