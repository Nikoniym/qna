require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to :ratingable }
  it { should validate_presence_of :like}
end
