require 'spec_helper'
describe BaseItem do
  describe '#self.packaging_types' do
    it 'each packaging type should have corresponding icon' do
      BaseItem.packaging_types.each do |pt|
        File.exists?(File.join( Rails.root, 'public', 'images', "pi_new/#{pt[:id]}.jpg")).should be_true
      end
    end
  end
end

