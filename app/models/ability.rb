class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is? :admin
      can :manage, :all
    else
#       can :read, :all
      can :manage, UserSession
      can :create, User if user.new_record?
      can [:show,:edit, :update], User, :id => user.id

      # Comment
      can :read, Comment if user.is? :retailer or user.is? :global_supplier

      # Receiver
      can :manage, Receiver if user.is? :global_supplier
    end
  end
end
