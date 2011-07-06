class AddMixToBaseItems < ActiveRecord::Migration
  def self.up
    add_column :base_items, :mix, :text

    unnecessary_fields = ['status', 'created_at','updated_at','user_id','despatch_unit','invoice_unit','order_unit','consumer_unit','item_id'] #fields for delete

    @base_items = BaseItem.find(:all)

    @base_items.each do |bi|
      attributes = bi.attributes
      unnecessary_fields.each do |uf|
	attributes.delete(uf)
      end

      bi.mix = attributes.values.join(' ') # what about "strong" separator, e.g. '%|^'
      bi.save
    end
  end

  def self.down
    remove_column :base_items, :mix
  end
end

