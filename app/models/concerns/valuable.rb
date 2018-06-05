module Valuable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :ratingable, dependent: :destroy
  end

  def number
    ratings.sum(:like)
  end

  def set_like?(user)
    ratings.where(like: 1, user: user).present?
  end

  def set_dislike?(user)
    ratings.where(like: -1, user: user).present?
  end

  def set_like!(user)
    transaction do
      destroy_dislike(user) if set_dislike?(user)
      ratings.create!(like: 1, user: user)
    end
  end

  def set_dislike!(user)
    transaction do
      destroy_like(user) if set_like?(user)
      ratings.create!(like: -1, user: user)
    end
  end

  def delete_vote!(user)
    transaction do
      destroy_dislike(user) if set_dislike?(user)
      destroy_like(user) if set_like?(user)
    end
  end

  def can_like?(user)
    !user.author_of?(self) && !set_like?(user)
  end

  def can_dislike?(user)
    !user.author_of?(self) && !set_dislike?(user)
  end

  def can_cancel_vote?(user)
    !user.author_of?(self) && (set_dislike?(user) || set_like?(user))
  end

  private

  def destroy_dislike(user)
    ratings.find_by(like: -1, user: user).destroy!
  end

  def destroy_like(user)
    ratings.find_by(like: 1, user: user).destroy!
  end
end