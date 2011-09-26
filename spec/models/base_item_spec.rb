require 'spec_helper'

describe BaseItem do

  fixtures :all

  before :each do
    @valid_attrs = {
      :user_id => users(:u10001).id,
      :item_id => items(:item11).id,
      :gtin => '43210121',
      :brand => '123',
      :functional => '123',
      :manufacturer_name => '123',
      :content => '123',
      :internal_item_id => '12345' * 4,
      :minimum_durability_from_arrival => '1234',
      :vat => 0.18,
      :content_uom => '123',
      :gpc_name => 10000115,
      :country_of_origin_code => 'RU',
      :item_description => '"Coca-Cola"',
      :manufacturer_gln => '4607099820661',
    }
    @valid_attrs2 = @valid_attrs.merge({
      :current_step => 'step2',
      :gross_weight => 5,
      :net_weight => 5,
      :height => 5,
      :depth => 5,
      :width => 5,
      :packaging_type => "SW1",
    })
    @pi_attrs = {
      :user_id => users(:u10001).id,
      :depth => 5,
      :height => 5,
      :width => 5,
      :number_of_next_lower_item => 1,
      :gross_weight => 50,
    }
  end

  it "should be valid" do
    object = BaseItem.new(@valid_attrs)
    object.valid?
    object.errors.should == {}
    object.should be_valid
    object = BaseItem.new(@valid_attrs2)
    object.valid?
    object.errors.should == {}
    object.should be_valid
  end

  it 'validates :user_id, :presence => true' do
    object = BaseItem.new(@valid_attrs.merge :user_id => nil)
    object.should_not be_valid
    object.errors_on(:user_id).should be_present
    BaseItem.new(@valid_attrs.merge :user_id => '').should_not be_valid
  end

  it 'validates :item_id, :presence => true' do
    object = BaseItem.new(@valid_attrs.merge :item_id => nil)
    object.should_not be_valid
    object.errors_on(:item_id).should be_present
    BaseItem.new(@valid_attrs.merge :item_id => '').should_not be_valid
  end

  it 'validates :gtin, :presence => true' do
    object = BaseItem.new(@valid_attrs.merge :gtin => '')
    object.should_not be_valid
    object.errors_on(:gtin).should be_present
  end

  it 'validates :gtin, :uniqueness => true, :conditions => :a_lot_of' do
    object = BaseItem.create(@valid_attrs2)
    new = BaseItem.new(@valid_attrs.merge :item_id => items(:item12))
    new.should be_valid
    object.publish!
    new.should_not be_valid
    new.errors_on(:gtin).should be_present
    pi = object.packaging_items.create(@pi_attrs.merge :gtin => '43220120')
    pi.errors.should == {}
    new = BaseItem.new(@valid_attrs.merge :gtin => '43220120')
    new.should_not be_valid
    new.errors_on(:gtin).should be_present
  end

  it 'validates :brand, :length => 1..70' do
    object = BaseItem.new(@valid_attrs.merge :brand => '')
    object.should_not be_valid
    object.errors_on(:brand).should be_present
    object = BaseItem.new(@valid_attrs.merge :brand => '0123456789'*7 + '0')
    object.should_not be_valid
    object.errors_on(:brand).should be_present
    BaseItem.new(@valid_attrs.merge :brand => '0123456789'*7).should be_valid
    BaseItem.new(@valid_attrs.merge :brand => 'a').should be_valid
  end

  it 'validates :subbrand, :length =>  { :maximum => 70 }, :allow_nil => true' do
    object = BaseItem.new(@valid_attrs.merge :subbrand => '0123456789'*7 + '0')
    object.should_not be_valid
    object.errors_on(:subbrand).should be_present
    BaseItem.new(@valid_attrs.merge :subbrand => '0123456789'*7).should be_valid
    BaseItem.new(@valid_attrs.merge :subbrand => 'a').should be_valid
  end

  it 'validates :functional, :length => 1..35' do
    object = BaseItem.new(@valid_attrs.merge :functional => '')
    object.should_not be_valid
    object.errors_on(:functional).should be_present
    object = BaseItem.new(@valid_attrs.merge :functional => '01234'*7 + '0')
    object.should_not be_valid
    object.errors_on(:functional).should be_present
    BaseItem.new(@valid_attrs.merge :functional => '01234'*7).should be_valid
    BaseItem.new(@valid_attrs.merge :functional => 'a').should be_valid
  end

  it 'validates :manufacturer_name, :length => 1..35' do
    object = BaseItem.new(@valid_attrs.merge :manufacturer_name => '')
    object.should_not be_valid
    object.errors_on(:manufacturer_name).should be_present
    object = BaseItem.new(@valid_attrs.merge :manufacturer_name => '01234'*7 + '0')
    object.should_not be_valid
    object.errors_on(:manufacturer_name).should be_present
    BaseItem.new(@valid_attrs.merge :manufacturer_name => '01234'*7).should be_valid
    BaseItem.new(@valid_attrs.merge :manufacturer_name => 'a').should be_valid
  end

  it 'validates :content, :numericality => {:greater_than => 0, :less_than_or_equal_to => 999999.999}' do
    object = BaseItem.new(@valid_attrs.merge :content => '')
    object.should_not be_valid
    object.errors_on(:content).should be_present
    object = BaseItem.new(@valid_attrs.merge :content => 'a')
    object.should_not be_valid
    object.errors_on(:content).should be_present
    object = BaseItem.new(@valid_attrs.merge :content => '0')
    object.should_not be_valid
    object.errors_on(:content).should be_present
    object = BaseItem.new(@valid_attrs.merge :content => '999999.9991')
    object.should_not be_valid
    object.errors_on(:content).should be_present
    BaseItem.new(@valid_attrs.merge :content => '999999.999').should be_valid
    BaseItem.new(@valid_attrs.merge :content => '1').should be_valid
  end

  it 'validates_number_length_of :internal_item_id, 20, :step => :first_step?' do
    object = BaseItem.new(@valid_attrs.merge :internal_item_id => 'abc')
    object.should_not be_valid
    object.errors_on(:internal_item_id).should be_present
    object = BaseItem.new(@valid_attrs.merge :internal_item_id => '0')
    object.should_not be_valid
    object.errors_on(:internal_item_id).should be_present
    object = BaseItem.new(@valid_attrs.merge :internal_item_id => '1.1')
    object.should_not be_valid
    object.errors_on(:internal_item_id).should be_present
    object = BaseItem.new(@valid_attrs.merge :internal_item_id => 10**20)
    object.should_not be_valid
    object.errors_on(:internal_item_id).should be_present
  end

  it 'validates_number_length_of :minimum_durability_from_arrival,
      4, :step => :first_step?' do
    object = BaseItem.new(@valid_attrs.merge :minimum_durability_from_arrival => '0')
    object.should_not be_valid
    object.errors_on(:minimum_durability_from_arrival).should be_present
    object = BaseItem.new(@valid_attrs.merge :minimum_durability_from_arrival => 'abc')
    object.should_not be_valid
    object.errors_on(:minimum_durability_from_arrival).should be_present
    object = BaseItem.new(@valid_attrs.merge :minimum_durability_from_arrival => '1.1')
    object.should_not be_valid
    object.errors_on(:minimum_durability_from_arrival).should be_present
    object = BaseItem.new(@valid_attrs.merge :minimum_durability_from_arrival => '12345')
    object.should_not be_valid
    object.errors_on(:minimum_durability_from_arrival).should be_present
  end

  it 'validates :vat, :presence => true, :numericality => true' do
    object = BaseItem.new(@valid_attrs.merge :vat => nil)
    object.should_not be_valid
    object.errors_on(:vat).should be_present
    object = BaseItem.new(@valid_attrs.merge :vat => '')
    object.should_not be_valid
    object.errors_on(:vat).should be_present
    object = BaseItem.new(@valid_attrs.merge :vat => 'a')
    object.should_not be_valid
    object.errors_on(:vat).should be_present
  end

  it 'validates :content_uom, :presence => true, :length => { :maximum => 3 }' do
    object = BaseItem.new(@valid_attrs.merge :content_uom => nil)
    object.should_not be_valid
    object.errors_on(:content_uom).should be_present
    object = BaseItem.new(@valid_attrs.merge :content_uom => '')
    object.should_not be_valid
    object.errors_on(:content_uom).should be_present
    object = BaseItem.new(@valid_attrs.merge :content_uom => '0'*4)
    object.should_not be_valid
    object.errors_on(:content_uom).should be_present
    object = BaseItem.new(@valid_attrs.merge :content_uom => '0'*3)
    object.should be_valid
    object.errors_on(:content_uom).should_not be_present
  end

  it 'validates :gpc_code, :presence => true, :numericality => true' do
    object = BaseItem.new(@valid_attrs.merge :gpc_code => nil)
    object.should_not be_valid
    object.errors_on(:gpc_code).should be_present
    object = BaseItem.new(@valid_attrs.merge :gpc_code => '')
    object.should_not be_valid
    object.errors_on(:gpc_code).should be_present
    object = BaseItem.new(@valid_attrs.merge :gpc_code => 'a')
    object.should_not be_valid
    object.errors_on(:gpc_code).should be_present
  end

  it 'validates :country_of_origin_code, :presence => true, :length => { :maximum => 2 }' do
    object = BaseItem.new(@valid_attrs.merge :country_of_origin_code => nil)
    object.should_not be_valid
    object.errors_on(:country_of_origin_code).should be_present
    object = BaseItem.new(@valid_attrs.merge :country_of_origin_code => '')
    object.should_not be_valid
    object.errors_on(:country_of_origin_code).should be_present
    object = BaseItem.new(@valid_attrs.merge :country_of_origin_code => 'A'*3)
    object.should_not be_valid
    object.errors_on(:country_of_origin_code).should be_present
    object = BaseItem.new(@valid_attrs.merge :country_of_origin_code => 'A'*2)
    object.should be_valid
    object.errors_on(:country_of_origin_code).should_not be_present
  end

  it 'validates :item_description, :presence => true, :length => { :maximum => 178 }' do
    object = BaseItem.new(@valid_attrs.merge :item_description => nil)
    object.should_not be_valid
    object.errors_on(:item_description).should be_present
    object = BaseItem.new(@valid_attrs.merge :item_description => '')
    object.should_not be_valid
    object.errors_on(:item_description).should be_present
    object = BaseItem.new(@valid_attrs.merge :item_description => 'a'*179)
    object.should_not be_valid
    object.errors_on(:item_description).should be_present
    object = BaseItem.new(@valid_attrs.merge :item_description => 'a'*178)
    object.should be_valid
    object.errors_on(:item_description).should_not be_present
  end

  it 'validates :manufacturer_gln, :presence => true, :length => { :maximum => 13' do
    object = BaseItem.new(@valid_attrs.merge :manufacturer_gln => nil)
    object.should_not be_valid
    object.errors_on(:manufacturer_gln).should be_present
    object = BaseItem.new(@valid_attrs.merge :manufacturer_gln => '')
    object.should_not be_valid
    object.errors_on(:manufacturer_gln).should be_present
    object = BaseItem.new(@valid_attrs.merge :manufacturer_gln => '0'*14)
    object.should_not be_valid
    object.errors_on(:manufacturer_gln).should be_present
    object = BaseItem.new(@valid_attrs.merge :manufacturer_gln => '0'*13)
    object.should be_valid
    object.errors_on(:manufacturer_gln).should_not be_present
  end

  describe 'only for the second step' do
    it 'validates_number_length_of :gross_weight, 7, :step => :last_step?' do
      object = BaseItem.new(@valid_attrs2.merge :gross_weight => '0')
      object.should_not be_valid
      object.errors_on(:gross_weight).should be_present
      object = BaseItem.new(@valid_attrs2.merge :gross_weight => 'abc')
      object.should_not be_valid
      object.errors_on(:gross_weight).should be_present
      object = BaseItem.new(@valid_attrs2.merge :gross_weight => '1.1')
      object.should_not be_valid
      object.errors_on(:gross_weight).should be_present
      object = BaseItem.new(@valid_attrs2.merge :gross_weight => 10**7)
      object.should_not be_valid
      object.errors_on(:gross_weight).should be_present
      object = BaseItem.new(@valid_attrs2.merge :gross_weight => 10**7, :current_step => 'step1')
      object.should be_valid
      object.errors_on(:gross_weight).should_not be_present
    end

    it 'validates_number_length_of :net_weight, 7, :allow_nil=> true, :step => :last_step?' do
      object = BaseItem.new(@valid_attrs2.merge :net_weight => '0')
      object.should_not be_valid
      object.errors_on(:net_weight).should be_present
      object = BaseItem.new(@valid_attrs2.merge :net_weight => '1.1')
      object.should_not be_valid
      object.errors_on(:net_weight).should be_present
      object = BaseItem.new(@valid_attrs2.merge :net_weight => 10**7)
      object.should_not be_valid
      object.errors_on(:net_weight).should be_present
      object = BaseItem.new(@valid_attrs2.merge :net_weight => nil)
      object.should be_valid
      object.errors_on(:net_weight).should_not be_present
      object = BaseItem.new(@valid_attrs2.merge :net_weight => 10**7, :current_step => 'step1')
      object.should be_valid
      object.errors_on(:net_weight).should_not be_present
    end

    it 'validates_number_length_of :height, 5, :step => :last_step?' do
      object = BaseItem.new(@valid_attrs2.merge :height => '0')
      object.should_not be_valid
      object.errors_on(:height).should be_present
      object = BaseItem.new(@valid_attrs2.merge :height => 'abc')
      object.should_not be_valid
      object.errors_on(:height).should be_present
      object = BaseItem.new(@valid_attrs2.merge :height => '1.1')
      object.should_not be_valid
      object.errors_on(:height).should be_present
      object = BaseItem.new(@valid_attrs2.merge :height => 10**5)
      object.should_not be_valid
      object.errors_on(:height).should be_present
      object = BaseItem.new(@valid_attrs2.merge :height => 10**5, :current_step => 'step1')
      object.should be_valid
      object.errors_on(:height).should_not be_present
    end

    it 'validates_number_length_of :depth, 5, :step => :last_step?' do
      object = BaseItem.new(@valid_attrs2.merge :depth => '0')
      object.should_not be_valid
      object.errors_on(:depth).should be_present
      object = BaseItem.new(@valid_attrs2.merge :depth => 'abc')
      object.should_not be_valid
      object.errors_on(:depth).should be_present
      object = BaseItem.new(@valid_attrs2.merge :depth => '1.1')
      object.should_not be_valid
      object.errors_on(:depth).should be_present
      object = BaseItem.new(@valid_attrs2.merge :depth => 10**5)
      object.should_not be_valid
      object.errors_on(:depth).should be_present
      object = BaseItem.new(@valid_attrs2.merge :depth => 10**5, :current_step => 'step1')
      object.should be_valid
      object.errors_on(:depth).should_not be_present
    end

    it 'validates_number_length_of :width, 5, :step => :last_step?' do
      object = BaseItem.new(@valid_attrs2.merge :width => '0')
      object.should_not be_valid
      object.errors_on(:width).should be_present
      object = BaseItem.new(@valid_attrs2.merge :width => 'abc')
      object.should_not be_valid
      object.errors_on(:width).should be_present
      object = BaseItem.new(@valid_attrs2.merge :width => '1.1')
      object.should_not be_valid
      object.errors_on(:width).should be_present
      object = BaseItem.new(@valid_attrs2.merge :width => 10**5)
      object.should_not be_valid
      object.errors_on(:width).should be_present
      object = BaseItem.new(@valid_attrs2.merge :width => 10**5, :current_step => 'step1')
      object.should be_valid
      object.errors_on(:width).should_not be_present
    end

    it 'validates :packaging_type, :presence => true, :length => { :maximum => 3 }' do
      object = BaseItem.new(@valid_attrs2.merge :packaging_type => nil)
      object.should_not be_valid
      object.errors_on(:packaging_type).should be_present
      object = BaseItem.new(@valid_attrs2.merge :packaging_type => '')
      object.should_not be_valid
      object.errors_on(:packaging_type).should be_present
      object = BaseItem.new(@valid_attrs2.merge :packaging_type => '0'*4)
      object.should_not be_valid
      object.errors_on(:packaging_type).should be_present
      object = BaseItem.new(@valid_attrs2.merge :packaging_type => '', :current_step => 'step1')
      object.should be_valid
      object.errors_on(:packaging_type).should_not be_present
    end

  end

  it 'assings the initial status' do
    object = BaseItem.new(@valid_attrs)
    object.aasm_current_state.should == :draft
  end

end
