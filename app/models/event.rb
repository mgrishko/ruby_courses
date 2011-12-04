class Event
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  TYPES = %w(added updated destroyed)
  
  field :type, type: String
  
  belongs_to :trackable, polymorphic: true
  belongs_to :account
  belongs_to :user
  
  validates :account, presence: true
  validates :user, presence: true
  validates :type, presence: true, inclusion: { in: TYPES }
  
  def type?(type)
    self.type == type.to_s
  end
end
