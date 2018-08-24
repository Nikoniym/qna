class Answer < ApplicationRecord
  include Valuable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(best: :desc) }

  validates :body, presence: true

  after_commit :job_sending_messages, on: :create

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def job_sending_messages
    SendNewAnswerJob.perform_later(self)
  end
end
