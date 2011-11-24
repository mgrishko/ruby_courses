class MembershipAbility
  include CanCan::Ability

  def initialize(membership)
    membership ||= Membership.new

    if membership.role? :admin
      can :manage, :all
      cannot [:update, :destroy], Account
      can :update, Account, owner_id: membership.user_id
      cannot [:update, :destroy], Membership, user_id: membership.account.owner_id
    elsif membership.role? :editor
      can :manage, Product
      can :read, :all
      cannot :read, Membership
    elsif membership.role? :contributor
      can :read, :all
      cannot :read, Membership
    elsif membership.role? :viewer
      can :read, :all
      cannot :read, Membership
    else
      cannot :read, :all
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
