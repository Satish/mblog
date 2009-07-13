class CreatePrivateMessages < ActiveRecord::Migration
  def self.up
    create_table :private_messages do |t|
      t.text        :message, :default => ''
      t.references  :sender, :receiver, :parent
      t.boolean :sender_deleted, :receiver_deleted, :read,  :default=> false

      t.timestamps
    end
  end

  def self.down
    drop_table :private_messages
  end
end
