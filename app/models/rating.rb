class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :ratingable, polymorphic: true, optional: true

  validates :like, presence: true
end
