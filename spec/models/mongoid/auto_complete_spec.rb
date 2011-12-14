require 'spec_helper'

describe Mongoid::AutoComplete do

  before do
    class Tag
      include Mongoid::Document
      field :name, type: String
      embedded_in :article
    end

    class Category
      include Mongoid::Document
      field :title, type: String
      field :code, type: String
      has_many :articles
    end

    class Article
      include Mongoid::Document
      include Mongoid::AutoComplete
      field :author, type: String
      embeds_many :tags
      belongs_to :category

      auto_complete_for :author, :tags => :name, :category => [:title, :code]
    end

    category = Category.create(title: "Fiction", code: 111)
    article  = Article.create(author: "Steven King", category: category)
    article.tags.create(name: "Must read")
    article.tags.create(name: "Horrible")

    category = Category.create(title: "Business", code: 222)
    article  = Article.create(author: "Richard Branson", category: category)
    article.tags.create(name: "Must read")
    article.tags.create(name: "Motivation")

    20.times { |i| article.tags.create(name: "Tag #{i}") }
  end

  describe "#auto_complete_for" do
    it "should define singleton complete method" do
      Article.field :title, type: String
      Article.auto_complete_for :title
      Article.singleton_methods.should include(:complete_title)
    end

    it "should raise error when model does not have field" do
      lambda { Article.auto_complete_for :bad_field }.
          should raise_error(RuntimeError, "Incorrect field bad_field for model Article")
    end

    it "should raise error when model does not have relation" do
      lambda { Article.auto_complete_for :publishers => :name }.
          should raise_error(RuntimeError, "Incorrect relation publishers for model Article")
    end

    it "should raise error when model relation does not have field" do
      lambda { Article.auto_complete_for :tags => :bad_field }.
          should raise_error(RuntimeError, "Incorrect field bad_field for model Tag")
    end
  end

  describe "complete methods" do
    it "should return values for field" do
      Article.complete_author("ste").should include("Steven King")
    end

    it "should return values for embedded relation field" do
      Article.complete_tags_name("m").should include("Must read")
    end

    it "should return values for belongs to relation field" do
      Article.complete_category_title("bu").should include("Business")
    end

    it "should return empty array for blank query" do
      Article.complete_tags_name("").should be_empty
    end

    it "should return only unique values" do
      Article.complete_tags_name("m").select{ |v| v == "Must read" }.size.should == 1
    end

    it "should limit values" do
      Article.complete_tags_name("tag", limit: 5).size.should == 5
    end

    it "should limit values by default" do
      Article.complete_tags_name("tag").size.should == 10
    end

    it "should sort values" do
      Article.complete_tags_name("m").first.should eql("Motivation")
    end
  end
end
