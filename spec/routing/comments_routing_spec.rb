require "spec_helper"

describe CommentsController do
  describe "routing" do

    context "product" do
      it "routes to #index" do
        get("http://subdomain.example.com/products/1/comments").should_not be_routable
      end

      it "routes to #new" do
        get("http://subdomain.example.com/products/1/comments/new").should_not be_routable
      end

      it "routes to #show" do
        get("http://subdomain.example.com/products/1/comments/1").should_not be_routable
      end

      it "routes to #edit" do
        get("http://subdomain.example.com/products/1/comments/1/edit").should_not be_routable
      end

      it "routes to #create" do
        post("http://subdomain.example.com/products/1/comments").
            should route_to("comments#create", product_id: "1")
      end

      it "routes to #update" do
        put("http://subdomain.example.com/products/1/comments/1").should_not be_routable
      end

      it "routes to #destroy" do
        delete("http://subdomain.example.com/products/1/comments/1").
            should route_to("comments#destroy", id: "1", product_id: "1")
      end
    end
  end
end
