require 'spec_helper'

describe CommentsController do

  it { should be_kind_of(MainController) }

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:comment, product: nil)
  end

  before(:each) do
    @product = Fabricate(:product)
    @subdomain = @product.account.subdomain
  end

  describe "POST create" do
    login_account_as :contributor, account: { subdomain: @subdomain }

    describe "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, product_id: @product.id, :comment => valid_attributes
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, product_id: @product.id, :comment => valid_attributes
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end

      it "redirects to the product page" do
        post :create, product_id: @product.id, :comment => valid_attributes
        response.should redirect_to(@product)
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        Comment.any_instance.stub_chain(:errors, :empty?).and_return(false)
      end

      it "assigns a newly created but unsaved comment as @comment" do
        post :create, product_id: @product.id, :comment => {}
        assigns(:comment).should be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        post :create, product_id: @product.id, :comment => {}
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested comment" do
      comment = Comment.create! valid_attributes
      expect {
        delete :destroy, product_id: @product.id, :id => comment.id
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      comment = Comment.create! valid_attributes
      delete :destroy, product_id: @product.id, :id => comment.id
      response.should redirect_to(comments_url)
    end
  end
end
