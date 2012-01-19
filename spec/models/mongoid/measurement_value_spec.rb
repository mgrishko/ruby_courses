require 'spec_helper'

describe Mongoid::MeasurementValue do

  before do
    class MeasurementExample
      include Mongoid::Document
      include Mongoid::MeasurementValue
      measurement_value_field :value
    end

    @content = MeasurementExample.new
  end

  describe "#measure_value_field" do
    it "should define field" do
      MeasurementExample.measurement_value_field :value2
      MeasurementExample.fields.should include("value2")
    end

    it "can define multiples fields at once" do
      MeasurementExample.measurement_value_field :value2, :value3
      MeasurementExample.fields.should include("value3")
    end

    it { @content.should allow_value("").for(:value) }

    it { @content.should allow_value("101234567890123").for(:value) }
    it { @content.should allow_value("0.01234567890123").for(:value) }
    it { @content.should_not allow_value("1.012345678901234").for(:value) } # very long, 15 digits only
    it { @content.should_not allow_value("1234567890123456").for(:value) } # very long, 15 digits only
    it { @content.should_not allow_value("123456789012345.6").for(:value) } # very long, 15 digits only
    it { @content.should_not allow_value("12345678.90123456").for(:value) } # very long, 15 digits only
    it { @content.should_not allow_value("-1").for(:value) }
    it { @content.should_not allow_value("0").for(:value) }
    it { @content.should_not allow_value("aaa").for(:value) } # not a digit
  end

  describe "attribute reader" do
    it "should return nil for blank value" do
      @content.value = ""
      @content.value.should be_nil
    end

    it "should return 2 significant digits" do
      @content.value = 500.23
      @content.value.to_s.should == "500.23"
    end

    it "should return zero significant digits" do
      @content.value = 500
      @content.value.to_s.should == "500"
    end

    it "should return properly treat with small numbers" do
      @content.value = 0.23
      @content.value.to_s.should == "0.23"
    end
  end
end
