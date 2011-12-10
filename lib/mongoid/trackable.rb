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
    # @param [eventable] The embedded object if an event should be logged for
    # an embedded object, then , nil otherwise
    # @return [Boolean] true if event has the specified type and false otherwise
    def log_event(current_membership, action_name, eventable = nil)
      if action_name.to_sym == :update
        event = Event.
          where(
            :action_name.in => ["create", "update"], 
            :created_at.gte => (Time.now - Settings.events.collapse_timeframe.minutes)).
          find_or_initialize_by(
            account_id: current_membership.account.id,
            user_id: current_membership.user.id, 
            trackable_id: self.id,
            trackable_type: self.class.name,
            eventable_id: eventable.nil? ? self.id : eventable.id,
            eventable_type: eventable.nil? ? self.class.name : eventable.class.name
          )
        
        event.action_name = action_name if event.new_record?
        event.save
      else
        Event.create(account: current_membership.account, 
          user: current_membership.user, 
          action_name: action_name, 
          trackable: self,
          eventable: eventable.nil? ? self : eventable
        )
      end
    end
  end
end