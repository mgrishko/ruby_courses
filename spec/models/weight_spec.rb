require 'spec_helper'

describe Weight do

  let(:weight) { Fabricate(:weight, gross: 200) }

  [:gross, :net].each do |field|
    it { weight.should allow_value("100.15").for(field) }
    it { weight.should_not allow_value("aaa").for(field) }
    it { should allow_mass_assignment_of(field) }
  end
  it { should validate_presence_of(:gross) }
  it { should_not validate_presence_of(:net) }

  it { should validate_presence_of(:unit) }
  it { should ensure_length_of(:unit).is_at_least(1).is_at_most(3) }
  it { should allow_mass_assignment_of(:unit) }
  it { should allow_value("GR").for(:unit) }
  it { should_not allow_value("MM").for(:unit) }

  it "should be embedded in package" do
    package = Fabricate(:package)
    weight = package.weights.build
    weight.package.should eql(package)
  end

  it "should not be valid when net weight is greater then gross weight" do
    weight.gross = "100"
    weight.net = "110"
    weight.should_not be_valid
  end
end