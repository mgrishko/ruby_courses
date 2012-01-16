class Measurement
  include Mongoid::Document

  MEASURES = %w(depth height width gross_weight net_weight net_content)
  UNITS = %w(MM ML GR)
  UNITS_BY_MEASURES = {
      depth: ["MM"],
      height: ["MM"],
      width: ["MM"],
      gross_weight: ["GR"],
      net_weight: ["GR"],
      net_content: ["MM", "GR", "ML"]
  }

  field :name, type: String
  field :value, type: String
  field :unit, type: String

  embedded_in :product

  validates :name, presence: true, inclusion: { in: MEASURES }
  validates :value, presence: true,
            numericality: { greater_than: 0 }, length: 1..16, format: /^\d{1,15}(\.\d{1,14})?$/

  validates :unit, presence: true, length: 1..3, inclusion: { in: UNITS }

  attr_accessible :name, :value, :unit
end