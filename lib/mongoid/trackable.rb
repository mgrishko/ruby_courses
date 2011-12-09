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
    # @param [event_source] The embedded object if an event should be logged for
    # an embedded object, then , nil otherwise
    # @return [Boolean] true if event has the specified type and false otherwise
    def log_event(current_membership, action_name, event_source = nil)
      Event.create(account: current_membership.account, 
        user: current_membership.user, 
        action_name: action_name, 
        trackable: self,
        trackable_event_source: event_source.nil? ? self : event_source
      )
    end
  end
end