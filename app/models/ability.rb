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
    can :changes, [Question, Answer], { user: user }

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :set_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best
    end

    can :new_comment, [Question, Answer]

    alias_action :like, :dislike, :cancel_vote, to: :vote
    can :vote, [Question, Answer] do |resource|
      !user.author_of?(resource)
    end
  end
end
