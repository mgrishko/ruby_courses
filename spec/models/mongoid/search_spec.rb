require 'spec_helper'

describe Mongoid::Search do

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
      include Mongoid::Search
      field :author, type: String
      embeds_many :tags
      belongs_to :category

      auto_complete_for :author, :tags => :name, :category => [:title, :code]
      filter_by :author, :tags => :name#, :category => [:title, :code]
    end

    category = Category.create(title: "Fiction", code: 111)
    @article1 = Article.create(author: "Steven King", category: category)
    @article1.tags.create(name: "Must read")
    @article1.tags.create(name: "Horrible")

    category = Category.create(title: "Business", code: 222)
    @article2 = Article.create(author: "Richard Branson", category: category)
    @article2.tags.create(name: "Must read")
    @article2.tags.create(name: "Motivation")

    50.times { Article.create(author: "Steven King") }
    20.times { |i| @article1.tags.create(name: "Tag #{i}") }
  end

  describe "#filter_by" do
    it "should define singleton filter method" do
      Article.field :title, type: String
      Article.filter_by :title
      Article.singleton_methods.should include(:by_title)
    end

    it "should define singleton distinct values method" do
      Article.field :title, type: String
      Article.filter_by :title
      Article.singleton_methods.should include(:distinct_titles)
    end

    it "should raise error when model does not have field" do
      lambda { Article.filter_by :bad_field }.
          should raise_error(RuntimeError, "Incorrect field bad_field for model Article")
    end

    it "should raise error when model does not have relation" do
      lambda { Article.filter_by :publishers => :name }.
          should raise_error(RuntimeError, "Incorrect relation publishers for model Article")
    end

    it "should raise error when model relation does not have field" do
      lambda { Article.filter_by :tags => :bad_field }.
          should raise_error(RuntimeError, "Incorrect field bad_field for model Tag")
    end
  end

  describe "#auto_complete_for" do
    it "should define singleton distinct values method" do
      Article.field :title, type: String
      Article.auto_complete_for :title
      Article.singleton_methods.should include(:distinct_titles)
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
      Article.distinct_authors(search: "ste").should include("Steven King")
    end

    it "should return values for embedded relation field" do
      Article.distinct_tags_names(search: "m").should include("Must read")
    end

    it "should return values for belongs to relation field" do
      Article.distinct_category_titles(search: "bu").should include("Business")
    end

    it "should return only unique values" do
      Article.distinct_tags_names(search: "m").select{ |v| v == "Must read" }.size.should == 1
    end

    it "should return all values for blank query" do
      Article.distinct_tags_names.size.should == 23
    end

    it "should limit values" do
      Article.distinct_tags_names(search: "tag", limit: 5).size.should == 5
    end

    it "should search by first characters" do
      Article.distinct_authors(search: "ing").should_not include("Steven King")
    end

    it "should sort values" do
      Article.distinct_tags_names(search: "m").first.should eql("Motivation")
    end
  end

  describe "filter methods" do
    it "should return self for blank query" do
      Article.by_author("").should eql(Article)
    end

    it "should filter by full match" do
      Article.by_author("Richard").all.should be_empty
    end

    describe "filter by field" do
      it "should include matched" do
        Article.by_author("Richard Branson").all.should include(@article2)
      end

      it "should not include unmatched" do
        Article.by_author("Richard Branson").all.should_not include(@article1)
      end
    end

    describe "filter by embedded relation field" do
      it "should include matched" do
        Article.by_tags_name("motivation").all.should include(@article2)
      end

      it "should not include unmatched" do
        Article.by_tags_name("motivation").all.should_not include(@article1)
      end
    end

    # ToDo: Implement (not implemented yet)
    #describe "filter by belongs to relation field" do
    #  it "should include matched" do
    #    Article.by_category_title("fictions").all.should include(@article1)
    #  end
    #
    #  it "should not include unmatched" do
    #    Article.by_category_title("fictions").all.should_not include(@article2)
    #  end
    #end
  end
end
