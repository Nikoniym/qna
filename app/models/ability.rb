class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]

    alias_action :update, :destroy, to: :changes
    can :changes, [Question, Answer], { user_id: user.id }

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :set_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best
    end

    can :new_comment, [Answer, Question]

    alias_action :like, :dislike, to: :vote

    can :vote, [Answer, Question] do |resource|
      !user.author_of?(resource)
    end

    can :cancel_vote, [Answer, Question] do |resource|
      !user.author_of?(resource) && (resource.set_dislike?(user) || resource.set_like?(user))
    end

    # can :like, [Answer, Question] do |resource|
    #   !user.author_of?(resource) && !resource.set_like?(user)
    # end
    #
    # can :dislike, [Answer, Question] do |resource|
    #   !user.author_of?(resource) && !resource.set_dislike?(user)
    # end
    #
    # can :cancel_vote, [Answer, Question] do |resource|
    #   !user.author_of?(resource) && (resource.set_dislike?(user) || resource.set_like?(user))
    # end
  end
end
