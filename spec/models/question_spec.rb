require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }


  it_behaves_like 'valued' do
    let(:resource) { create(:question, user: create(:user)) }
  end
end

