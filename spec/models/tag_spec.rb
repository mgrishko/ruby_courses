require 'spec_helper'

describe Tag do
  let(:tag) { Fabricate(:tag) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_least(1).is_at_most(Settings.tags.maximum_length) }
  it { should allow_mass_assignment_of(:name) }
  it { should normalize_attribute(:name).from(" ta  g1 ").to("ta g1") }

  describe "name uniqueness validation" do
    it "should be unique in taggable scope" do
      taggable = Fabricate(:product)

      2.times { taggable.tags.build(name: "tag") }
      taggable.valid?
      taggable.should_not be_valid
      taggable.should have(1).error_on("tags")
    end

    it "should allow same tag for different taggables" do
      taggable1 = Fabricate(:product)
      taggable2 = Fabricate(:product)

      [taggable1, taggable2].each { |t| t.tags.build(name: "tag") }
      [taggable1, taggable2].each do |taggable|
        taggable.should be_valid
      end
    end
  end

  it "should be embedded in taggable" do
    taggable = Fabricate(:product)
    tag = taggable.tags.build
    tag.taggable.should eql(taggable)
  end
end
