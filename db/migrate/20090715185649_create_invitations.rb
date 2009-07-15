class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :email, :limit => 100
      t.string :invitation_code, :limit => 40
      t.string :state, :default => "pending"
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
