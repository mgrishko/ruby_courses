class Tag
  include Mongoid::Document

  field :name, type: String

  ## Attr Normalization
  normalize_attribute :name, :with => [:squish]
  
  embedded_in :taggable, polymorphic: true

  validates :name,
            presence: true,
            length: 1..Settings.tags.maximum_length,
            uniqueness: { case_insensitive: true, scope: :taggable }

  attr_accessible :name
end