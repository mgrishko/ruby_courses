require 'spec_helper'

describe CommentsController do

  it { should be_kind_of(MainController) }

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:comment, commentable: nil, user: nil)
  end

  context "product comment" do

    describe "POST create" do
      login_account_as :contributor, account: { subdomain: "company" }

      before(:each) do
        account = Account.first
        @product = Fabricate(:product, account: account)
      end

      describe "with valid params" do
        it "creates a new Comment" do
          @product.comments.count.should == 0
          post :create, product_id: @product.id, :comment => valid_attributes, format: :js
          @product.reload.comments.count.should == 1
        end

        it "assigns a newly created comment as @comment" do
          post :create, product_id: @product.id, :comment => valid_attributes, format: :js
          assigns(:comment).should be_a(Comment)
          assigns(:comment).should be_persisted
        end

        it "sets @comment user to current user" do
          post :create, product_id: @product.id, :comment => valid_attributes, format: :js
          assigns(:comment).user.should eql(@current_user)
        end

        it "redirects to the product page" do
          post :create, product_id: @product.id, :comment => valid_attributes, format: :js
          response.should render_template("create")
        end
      end

      describe "with invalid params" do
        before(:each) do
          # Trigger the behavior that occurs when invalid params are submitted
          Comment.any_instance.stub(:save).and_return(false)
          Comment.any_instance.stub_chain(:errors, :empty?).and_return(false)
        end

        it "assigns a newly created but unsaved comment as @comment" do
          post :create, product_id: @product.id, :comment => {}, format: :js
          assigns(:comment).should be_a_new(Comment)
        end

        it "redirects to the product page" do
          post :create, product_id: @product.id, :comment => {}, format: :js
          response.should render_template("create")
        end
      end
    end

    describe "DELETE destroy" do
      login_account_as :contributor, account: { subdomain: "company" }

      before(:each) do
        account = Account.first
        @product = Fabricate(:product, account: account)
        @comment = Fabricate(:comment, commentable: @product, user: @current_user)
      end

      it "destroys the requested comment" do
        @product.comments.count.should == 1
        delete :destroy, product_id: @product.id, :id => @comment.id, format: :js
        @product.reload.comments.count.should == 0
      end

      it "redirects to the product page" do
        delete :destroy, product_id: @product.id, :id => @comment.id, format: :js
        response.should render_template("destroy")
      end
    end
  end
end
