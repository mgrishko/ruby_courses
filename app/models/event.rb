class Event
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  ACTION_NAMES = %w(create update destroy)
  ADMIN_ONLY_TRACKABLE_CLASSES = %w(Account Membership)
  
  default_scope where(:eventable_type.nin => ADMIN_ONLY_TRACKABLE_CLASSES)

  field :action_name, type: String
  field :name, type: String
  
  belongs_to :trackable, polymorphic: true
  belongs_to :eventable, polymorphic: true
  belongs_to :account, index: true
  belongs_to :user

  index(
    [
      [ :created_at, Mongo::DESCENDING ],
      [ :eventable_type, Mongo::ASCENDING ]
    ]
  )
  
  validates :account, presence: true
  validates :user, presence: true
  validates :trackable, presence: true
  validates :eventable, presence: true
  validates :name, presence: true
  validates :action_name, presence: true, inclusion: { in: ACTION_NAMES }

  before_validation :prepare_event
  
  # Checks if event has a specific action name.
  #
  # @param [String] action name.
  # @return [Boolean] true if event has the specified action name and false otherwise.
  def action_name?(action_name)
    self.action_name == action_name.to_s
  end

  private

  # Stores the name of the trackable object in the event and sets
  # eventable to trackable if eventable is not set
  def prepare_event
    self.name = self.trackable.name unless self.trackable.nil?
    if self.eventable.nil? && !self.trackable.nil?
      self.eventable = self.trackable
    end
  end
end
