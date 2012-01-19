require 'spec_helper'

describe Dimension do

  let(:dimension) { Fabricate(:dimension) }

  [:depth, :height, :width].each do |field|
    it { should validate_presence_of(field) }
    it { should allow_value("100.15").for(field) }
    it { should_not allow_value("aaa").for(field) }
    it { should allow_mass_assignment_of(field) }
  end

  it { should validate_presence_of(:unit) }
  it { should ensure_length_of(:unit).is_at_least(1).is_at_most(3) }
  it { should allow_mass_assignment_of(:unit) }
  it { should allow_value("MM").for(:unit) }
  it { should_not allow_value("GR").for(:unit) }

  it "should be embedded in package" do
    package = Fabricate(:package)
    dimension = package.dimensions.build
    dimension.package.should eql(package)
  end
end