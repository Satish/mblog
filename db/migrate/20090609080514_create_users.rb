class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string        :name,    :limit => 100, :default => '', :null => true
      t.string        :email,   :limit => 100
      t.string        :login, :crypted_password, :salt, :activation_code, :remember_token, :limit => 40
      t.string        :state,   :null => :no, :default => 'passive'
      t.string        :identity_url, :timezone, :url, :bio, :location, :lang, :twitter_username
      t.datetime      :activated_at, :deleted_at, :visited_at, :remember_token_expires_at
      t.integer       :followers_count, :followings_count, :owned_messages_count, :attached_messages_count, :addressed_messages_count, :default => 0

      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end
