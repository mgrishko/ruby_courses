class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is? :admin
      can :manage, :all
      cannot :activate, User, :id => user.id
    else
#       can :read, :all
      can :manage, UserSession
      can :create, User if user.new_record?
      can [:show,:edit, :update], User, :id => user.id

      # User
      can [:show, :update], User, :id => user.id

      # BaseItem
      can [
        :read, :create, :update, :delete,
        :published, :draft, :accept, :reject, :classifier
      ], BaseItem,
          :user_id => user.id if user.is? :local_supplier or
            user.is? :global_supplier
      can :read, BaseItem, BaseItem.readably_by(user) do |base_item|
        base_item.receivers.count == 0 or
          base_item.dedicated_users.include? user
      end if user.is? :retailer
      can :export, BaseItem,
          :user_id => user.id if user.is? :export_allowed and
              (user.is? :local_supplier or
                user.is? :global_supplier)
      can :export, BaseItem, BaseItem.readably_by(user) do |base_item|
        base_item.receivers.count == 0 or
          base_item.dedicated_users.include? user
      end if user.is? :export_allowed and user.is? :retailer

      # Comment
      can :read, Comment if user.is? :retailer or user.is? :global_supplier

      # Receiver
      can :manage, Receiver if user.is? :global_supplier
    end
  end
end
