class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  has_many :ratings, as: :ratingable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  accepts_nested_attributes_for :ratings

  validates :title, :body, presence: true


end
