class CreateInvitationRequests < ActiveRecord::Migration
  def self.up
    create_table :invitation_requests do |t|
      t.string :email
      t.string :name
      t.string :company_name
      t.text :notes
      t.string :status
      t.integer :roles_mask

      t.timestamps
    end
  end

  def self.down
    drop_table :invitation_requests
  end
end
