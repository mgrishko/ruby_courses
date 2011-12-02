class Product
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :updated_at, versioned: true

  belongs_to :account
  embeds_many :comments, as: :commentable#, versioned: false

  validates :name, presence: true, length: 1..70
  validates :description, presence: true, length: 5..1000
  validates :account, presence: true
  
  # :version, :updated_at attributes required for Mongoid versioning support
  attr_accessible :name, :description, :version, :updated_at

  # Prepares comment for create and update actions
  def prepare_comment(user, attrs = {})
    comment = Comment.new(attrs)
    comment.created_at = Time.now
    comment.user = user
    if comment.body.present? && comment.valid?
      self.comments << comment
    end
    comment
  end
  
  # Returns a specific version
  def load_version!(version=nil)
    return if !version_exists?(version)
    return self if version.nil? || version == self.version
    self.attributes = versions.where(version: version.to_i).first.versioned_attributes
  end
  
  # Returns true if product version exists
  def version_exists?(version)
    version == self.version || versions.where(version: version).first
  end
  
  def get_version_dates
    version_dates = [[self.version, self.updated_at]]
    versions.reverse_each { |v| version_dates << [v.version, v.updated_at] }
    return version_dates
  end
end
