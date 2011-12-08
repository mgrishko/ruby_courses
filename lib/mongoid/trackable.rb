module Mongoid
  module Trackable
    extend ActiveSupport::Concern

    included do
      has_many :events, as: :trackable
    end
  
    # Creates Event object that stores the information about 
    # an action that was performed with the trackable object
    # 
    # @param [current_membership] Current membership
    # @param [action_name] Name of the controller action: create, update, destroy
    # @param [child_object] If event should be logged for an embedded object,
    # then the embedded object class name, nil otherwise
    # @return [Boolean] true if event has the specified type and false otherwise
    def log_event(current_membership, action_name, child_object = nil)
      Event.create(account: current_membership.account, 
        user: current_membership.user, 
        type: action_name, 
        trackable: self,
        trackable_child_type: child_object.nil? ? nil : child_object.class.name
      )
    end
  end
end