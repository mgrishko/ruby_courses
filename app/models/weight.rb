class Weight
  include Mongoid::Document
  include Mongoid::MeasurementValue

  UNITS = %w(GR)

  measurement_value_field :gross
  measurement_value_field :net
  field :unit, type: String

  embedded_in :package

  validates :gross, presence: true
  validates :net, numericality: { greater_than: 0, less_than: :gross }, allow_blank: true, unless: lambda { |a| a.gross.blank? }
  validates :unit, presence: true, length: 1..3, inclusion: { in: UNITS }

  attr_accessible :gross, :net, :unit
end