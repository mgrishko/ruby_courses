class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :gln
      t.string :pw_hash
      t.string :persistence_token

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
