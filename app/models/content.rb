class Content
  include Mongoid::Document
  include Mongoid::MeasurementValue

  UNITS = %w(GR ML MM)

  measurement_value_field :value
  field :unit, type: String

  embedded_in :package

  validates :value, presence: true
  validates :unit, presence: true, length: 1..3, inclusion: { in: UNITS }

  attr_accessible :value, :unit
end