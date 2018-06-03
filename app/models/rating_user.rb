class RatingUser < ApplicationRecord
  belongs_to :user
  belongs_to :rating
end
