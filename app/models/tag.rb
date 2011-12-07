class Tag
  include Mongoid::Document

  field :name, type: String

  embedded_in :taggable, polymorphic: true

  validates :name,
            presence: true,
            length: 1..Settings.tags.maximum_length,
            uniqueness: { case_insensitive: true, scope: :taggable }

  attr_accessible :name
end