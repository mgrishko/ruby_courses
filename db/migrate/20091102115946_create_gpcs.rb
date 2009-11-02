class CreateGpcs < ActiveRecord::Migration
  def self.up
    create_table :gpcs do |t|
      t.string :name
      t.integer :gpc_id

      t.timestamps
    end
  end

  def self.down
    drop_table :gpcs
  end
end
