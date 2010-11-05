require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActionController::Base do

  it "should include Cesium::Extentions::ApplicationController" do
    ActionController::Base.should include Terbium::Extentions::ApplicationController
  end

end

describe ActiveRecord::Base do

  it "should include Cesium::Extentions::ActiveRecord" do
   ActiveRecord::Base.should include Terbium::Extentions::ActiveRecord
  end

end
