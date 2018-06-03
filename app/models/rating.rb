class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true, optional: true

  has_many :rating_users, dependent: :destroy
  has_many :users, through: :rating_users
end
