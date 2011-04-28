class UpdateMixFieldInBaseItems < ActiveRecord::Migration
  def self.up
    @base_items = BaseItem.find(:all)
    @base_items.each do |bi|
      bi.save
    end
  end

  def self.down
  end
end
