require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to :ratingable }
  it { should belong_to :user }
end
