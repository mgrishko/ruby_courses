require 'spec_helper'

describe "products/show.html.haml" do
  before(:each) do
    version_dates = [[1, Date.parse('2001-02-03')], [2, Date.parse('2001-02-04')]]
    @version_dates = assign(:version_dates, version_dates)
    
    product = Fabricate.build(:product_with_comments)
    decorator = ProductDecorator.decorate(product)
    @product = assign(:product, decorator)
    @product.stub(:edit_link)
    @product.stub(:destroy_link)
    @product.stub(:show_version_link).with(1).and_return('<a>Version 1</a>'.html_safe)
    @product.stub(:show_version_link).with(2).and_return('<a>Version 2</a>'.html_safe)
    @product.stub(:format_date).with(Date.parse('2001-02-03')).and_return("Feb 03, 2001")
    @product.stub(:format_date).with(Date.parse('2001-02-04')).and_return("Feb 04, 2001")
    
    @comment = assign(:comment, stub_model(Comment,
      :commentable => product
    ).as_new_record)

    @comments = assign(:comments, CommentDecorator.decorate([stub_model(Comment,
      Fabricate.attributes_for(:comment, commentable: product, created_at: Time.now)
    )]))

    CommentDecorator.any_instance.stub(:destroy_link)
    view.stub(:can?).and_return(true)
  end

  describe "content" do
    it "should not render body title" do
      render
      rendered.should_not have_selector(".content header h1")
    end

    it "renders a product title" do
      render
      rendered.should have_selector("article header h2", text: @product.name)
    end

    it "renders a product description" do
      render
      rendered.should have_selector("article p", text: @product.description)
    end
  end

  describe "sidebar" do
    it "renders a product image" do
      render
      view.content_for(:sidebar).should have_selector("img")
    end

    it "renders a back link" do
      render
      view.content_for(:sidebar).should have_selector("a", text: "Back")
    end

    it "renders product versions header" do
      render
      view.content_for(:sidebar).should have_selector("h3", text: "Versions")
    end

    it "renders product version links with decorator" do
      render
      view.content_for(:sidebar).should have_selector("a", text: "Version 1")
      view.content_for(:sidebar).should have_selector("a", text: "Version 2")
    end

    it "renders product version dates with decorator" do
      render
      view.content_for(:sidebar).should have_selector("span", text: "Feb 03, 2001")
      view.content_for(:sidebar).should have_selector("span", text: "Feb 04, 2001")
    end

    it "renders an edit link" do
      @product.should_receive(:edit_link).with(class: "btn large")
      render
    end
    
    it "renders a destroy link" do
      @product.should_receive(:destroy_link).with(class: "btn small danger")
      render
    end
  end

  describe "comments" do
    it "renders new comment form" do
      render
      rendered.should have_selector("form", action: product_comments_path(@product.id),
                                    method: "post", "data-remote" => true)
    end
  end
end
