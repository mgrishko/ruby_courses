require 'spec_helper'

describe User do

  def mock_notifier
    (@notifier ||= mock_model('DummyNotifier').as_null_object).tap do |notifier|
       notifier.stub :deliver => true
    end
  end

  before :each do
    @valid_attrs = {
      :gln => '123',
      :password => 'user password',
      :password_confirmation => 'user password',
    }
  end

  describe 'class' do
    it 'should have ROLES ' do
      User::ROLES.should ==
        %w[admin retailer local_supplier global_supplier]
    end

    it 'should respond to :retailers' do
      User.retailers.should == []
    end

    it 'should respond to :suppliers' do
      User.suppliers.should == []
    end

    it 'should respond to :local_suppliers' do
      User.local_suppliers.should == []
    end

    it 'should respond to :global_suppliers' do
      User.global_suppliers.should == []
    end
  end

  it "should be valid" do
    User.new(@valid_attrs).should be_valid
  end

  it 'should respond to :roles=, :roles, and :is?' do
    user = User.create(@valid_attrs)
    user.roles.should == []
    user.roles = %w[admin retailer]
    user.roles.should == %w[admin retailer]
    user.is?(:admin).should == true
    user.is?('local_supplier').should == false
  end

  it 'should respond to :supplier?' do
    user = User.create(@valid_attrs)
    user.supplier?.should == false
    user.roles = %w[local_supplier]
    user.supplier?.should == true
    user.roles = %w[global_supplier]
    user.supplier?.should == true
  end

  it 'should respond to :retailer?' do
    user = User.create(@valid_attrs)
    user.retailer?.should == false
    user.roles = %w[retailer]
    user.retailer?.should == true
  end

  it 'should respond to :is_admin?' do
    user = User.create(@valid_attrs)
    user.is_admin?.should == false
    user.roles = %w[admin]
    user.is_admin?.should == true
  end

end

