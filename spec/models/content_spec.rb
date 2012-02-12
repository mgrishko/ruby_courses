require 'spec_helper'

describe Content do

  let(:content) { Fabricate(:content) }

  it { should validate_presence_of(:value) }
  it { should allow_value("100.15").for(:value) }
  it { should_not allow_value("aaa").for(:value) }
  it { should allow_mass_assignment_of(:value) }

  it { should validate_presence_of(:unit) }
  it { should ensure_length_of(:unit).is_at_least(1).is_at_most(3) }
  it { should allow_mass_assignment_of(:unit) }
  it { should allow_value("GR").for(:unit) }
  it { should allow_value("MM").for(:unit) }
  it { should allow_value("ML").for(:unit) }
  it { should allow_value("1N").for(:unit) }
  it { should_not allow_value("AA").for(:unit) }

  it "should be embedded in package" do
    package = Fabricate(:package)
    content = package.contents.build
    content.package.should eql(package)
  end
end