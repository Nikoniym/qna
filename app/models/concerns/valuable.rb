module Valuable
  extend ActiveSupport::Concern

  included do
    has_one :rating, as: :ratingable, dependent: :destroy
    after_create :create_rating
  end

  def number
    rating.rating_count
  end

  def set_like?(user)
    rating.rating_users.where( like: true, user: user ).present?
  end

  def set_dislike?(user)
    rating.rating_users.where(like: false, user: user).present?
  end

  def set_like!(user)
    transaction do
      destroy_dislike(user) if set_dislike?(user)
      rating.update(rating_count: number + 1)
      rating.rating_users.create!(like: true, user: user)
    end
  end

  def set_dislike!(user)
    transaction do
      destroy_like(user) if set_like?(user)
      rating.update(rating_count: number - 1)
      rating.rating_users.create!(like: false, user: user)
    end
  end

  def delete_vote!(user)
    destroy_dislike(user) if set_dislike?(user)
    destroy_like(user) if set_like?(user)
  end

  private

  def create_rating
    Rating.create(ratingable: self)
  end

  def destroy_dislike(user)
    rating.update(rating_count: number + 1) if rating.rating_users.find_by(like: false, user: user).destroy
  end

  def destroy_like(user)
    rating.update(rating_count: number - 1) if rating.rating_users.find_by(like: true, user: user).destroy
  end

  def like
    rating.rating_users.where(like: true).count
  end

  def dislike
    rating.rating_users.where(like: false).count
  end
end