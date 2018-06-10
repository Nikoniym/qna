class Question < ApplicationRecord
  include Valuable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  belongs_to :user

  validates :title, :body, presence: true
end
