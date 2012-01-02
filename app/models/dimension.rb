class Dimension
  include Mongoid::Document
  include Mongoid::MeasurementValue

  UNITS = %w(MM)

  measurement_value_field :depth
  measurement_value_field :height
  measurement_value_field :width
  field :unit, type: String

  embedded_in :package

  validates :depth, presence: true
  validates :height, presence: true
  validates :width, presence: true
  validates :unit, presence: true, length: 1..3, inclusion: { in: UNITS }

  attr_accessible :depth, :height, :width, :unit
end