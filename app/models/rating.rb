class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true, optional: true

  belongs_to :user
end
