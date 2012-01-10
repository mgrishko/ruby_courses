module Mongoid
  module Trackable
    extend ActiveSupport::Concern

    included do
      has_many :events, as: :trackable
    end
  
    # Creates Event object that stores the information about 
    # an action that was performed with the trackable object
    # 
    # @param [action_name] Name of the controller action: create, update, destroy
    # @param [eventable] The embedded object if an event should be logged for
    # an embedded object, then , nil otherwise
    # @return [Boolean] true if event has the specified type and false otherwise
    def log_event(action_name, eventable = nil)
      return unless Membership.current
      
      if action_name.to_sym == :update
        event = Event.
          where(
            :action_name.in => ["create", "update"], 
            :created_at.gte => (Time.now - Settings.events.collapse_timeframe.minutes)).
          find_or_initialize_by(
            account_id: Membership.current.account.id,
            user_id: Membership.current.user.id, 
            trackable_id: self.id,
            trackable_type: self.class.name,
            eventable_id: eventable.nil? ? self.id : eventable.id,
            eventable_type: eventable.nil? ? self.class.name : eventable.class.name
          )
        
        event.action_name = action_name if event.new_record?
        event.save
      else
        event = Event.create(account: Membership.current.account, 
          user: Membership.current.user, 
          action_name: action_name, 
          trackable: self,
          eventable: eventable.nil? ? self : eventable
        )
      end
      event
    end
  end
end