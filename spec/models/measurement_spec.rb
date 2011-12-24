require 'spec_helper'

describe Measurement do

  let(:measurement) { Fabricate(:measurement) }

  it { should validate_presence_of(:name) }
  it { should allow_value("depth").for(:name) }
  it { should allow_value("gross_weight").for(:name) }
  it { should allow_value("height").for(:name) }
  it { should allow_value("width").for(:name) }
  it { should allow_value("net_content").for(:name) }
  it { should allow_value("net_weight").for(:name) }
  it { should_not allow_value("Depth").for(:name) }
  it { should_not allow_value("unknown").for(:name) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:value) }
  it { should validate_numericality_of(:value) }
  it { should allow_value("101234567890123").for(:value) }
  it { should allow_value("0.01234567890123").for(:value) }
  it { should_not allow_value("0.1.23").for(:value) }
  it { should_not allow_value("1.012345678901234").for(:value) } # very long, 15 digits only
  it { should_not allow_value("1234567890123456").for(:value) } # very long, 15 digits only
  it { should_not allow_value("123456789012345.6").for(:value) } # very long, 15 digits only
  it { should_not allow_value("12345678.90123456").for(:value) } # very long, 15 digits only
  it { should_not allow_value("-1").for(:value) }
  it { should_not allow_value("0").for(:value) }
  it { should_not allow_value("aaa").for(:value) } # not a digit
  it { should allow_mass_assignment_of(:value) }

  it { should validate_presence_of(:unit) }
  it { should ensure_length_of(:unit).is_at_least(1).is_at_most(3) }
  it { should allow_mass_assignment_of(:unit) }
  it { should_not allow_value("AA").for(:unit) }

  %w(depth height width gross_weight net_weight net_content).each do |name|
    context "#{name}" do
      %w(MM GR ML).each do |unit|

        allow_unit = Measurement::UNITS_BY_MEASURES[name.to_sym].include?(unit)

        it "should#{ allow_unit ? "" : " not"} allow #{unit}" do
          measurement = Fabricate.build(:measurement, name: name, unit: unit)
          measurement.valid?
          count = allow_unit ? 0 : 1
          measurement.should have(count).error_on("value")
        end
      end
    end
  end

  it "should be embedded in product" do
    product = Fabricate(:product)
    measurement = product.measurements.build
    measurement.product.should eql(product)
  end
end