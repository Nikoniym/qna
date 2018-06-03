require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to :ratingable }
  it { should have_many(:users) }
  it { should have_many(:rating_users).dependent(:destroy) }
end
