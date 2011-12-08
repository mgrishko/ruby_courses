class Event
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  TYPES = %w(create update destroy)
  
  field :type, type: String
  field :name, type: String
  field :trackable_child_type, type: String
  
  belongs_to :trackable, polymorphic: true
  belongs_to :account
  belongs_to :user
  
  validates :account, presence: true
  validates :user, presence: true
  validates :type, presence: true, inclusion: { in: TYPES }
  
  # Stores the name of the trackable object in the event
  set_callback(:create, :before) do |comment|
    self.name = trackable.name
  end
  
  # Checks if event has a specific type
  #
  # @param [String] event type
  # @return [Boolean] true if event has the specified type and false otherwise
  def type?(type)
    self.type == type.to_s
  end
end
