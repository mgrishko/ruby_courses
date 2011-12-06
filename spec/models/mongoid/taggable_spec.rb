require 'spec_helper'

describe Mongoid::Taggable do
  let(:tag) { Fabricate(:tag) }

  before(:each) do
    @taggable = Fabricate(:product)
  end

  it "should embed many tags" do
    tag = @taggable.tags.build
    @taggable.tags.should include(tag)
  end

  describe "tags_list accessor" do
    it "returns embedded tags as a string" do
      3.times { |i| @taggable.tags.build name: "tag#{i+1}" }
      @taggable.save!
      @taggable.tags_list.should == "tag1, tag2, tag3"
    end

    it "allows mass assignment" do
      taggable = Fabricate(:product, tags_list: "tag1, tag2")
      taggable.tags_list == "tag1, tag2"
    end

    it "creates embedded tags" do
      @taggable.tags_list = "tag1, tag2"
      @taggable.save!
      @taggable.tags.map(&:name).should eql(["tag1", "tag2"])
    end
  end

  describe "tags changes" do
    before(:each) do
      2.times { |i| @taggable.tags.build name: "tag#{i+1}" }
      @taggable.save!
    end

    context "when taggable is valid" do
      it "updates embedded tags" do
        # removing tag1 and adding tag3
        @taggable.tags_list = "tag2, tag3"
        @taggable.save!
        @taggable.reload
        @taggable.tags.map(&:name).should eql(["tag2", "tag3"])
      end
    end

    context "when taggable is invalid" do
      it "should not update embedded tags" do
        @taggable.tags_list = "tag2 tag3"
        @taggable.name = nil
        @taggable.should_not be_valid
        @taggable.reload
        @taggable.tags.map(&:name).should eql(["tag1", "tag2"])
      end
    end
  end
end
