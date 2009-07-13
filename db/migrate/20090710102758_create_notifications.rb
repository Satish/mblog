class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.boolean :email_on_new_follower, :email_on_new_direct_message, :email_on_new_reply,  :default => false
      t.boolean :email_newsletter, :email_updates,  :default => true
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
