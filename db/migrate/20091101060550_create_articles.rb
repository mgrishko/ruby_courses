class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :record_code
      t.string :name
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
