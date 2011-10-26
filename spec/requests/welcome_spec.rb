require 'spec_helper'

describe "Welcome" do
  describe "GET /welcome" do
    it "works! (now write some real specs)" do
      get root_path
      response.status.should be(200)
    end
  end
end
