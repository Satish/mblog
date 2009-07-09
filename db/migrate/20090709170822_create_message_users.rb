class CreateMessageUsers < ActiveRecord::Migration
  def self.up
    create_table :message_users do |t|
      t.references :user, :message
      t.timestamps
    end
  end

  def self.down
    drop_table :message_users
  end
end
