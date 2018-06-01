class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :ratings, as: :ratingable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  accepts_nested_attributes_for :ratings

  default_scope { order(best: :desc) }

  validates :body, presence: true

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
