class Event
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  # Stores the name of the trackable object in the event and sets
  # trackable_event_source to trackable if trackable_event_source is not set
  before_validation Proc.new { |event| 
    event.name = event.trackable.name unless event.trackable.nil?
    if event.trackable_event_source.nil? && !event.trackable.nil?
      event.trackable_event_source = event.trackable
    end
  }
  
  ACTION_NAMES = %w(create update destroy)
  
  field :action_name, type: String
  field :name, type: String
  #field :trackable_child_type, type: String
  
  belongs_to :trackable, polymorphic: true
  belongs_to :trackable_event_source, polymorphic: true
  belongs_to :account
  belongs_to :user
  
  validates :account, presence: true
  validates :user, presence: true
  validates :trackable, presence: true
  validates :trackable_event_source, presence: true
  validates :name, presence: true
  validates :action_name, presence: true, inclusion: { in: ACTION_NAMES }
  
  # Checks if event has a specific action name.
  #
  # @param [String] action name.
  # @return [Boolean] true if event has the specified action name and false otherwise.
  def action_name?(action_name)
    self.action_name == action_name.to_s
  end
end
