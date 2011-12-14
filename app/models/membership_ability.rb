class MembershipAbility
  include CanCan::Ability

  def initialize(membership)
    membership ||= Membership.new

    if membership.role? :admin
      can :manage, :all
      cannot :manage, Account
      cannot [:update, :destroy], Membership, user_id: membership.account.owner_id
      cannot :destroy, Comment, { :event_id.exists => true }
      
    elsif membership.role? :editor
      can :read, :all
      can :manage, Product
      can :create, Comment
      can :destroy, Comment, { :user_id => membership.user_id, :event_id.exists => false }
      can :manage, Photo
      cannot :read, Membership

    elsif membership.role? :contributor
      can :read, :all
      cannot :read, Membership
      can :create, Comment
      can :destroy, Comment, { :user_id => membership.user_id, :event_id.exists => false }

    elsif membership.role? :viewer
      can :read, :all
      cannot :read, Membership

    else
      cannot :read, :all
    end

    if !membership.new_record? && membership.owner?
      can :update, Account, owner_id: membership.user_id
    end
  end
end
