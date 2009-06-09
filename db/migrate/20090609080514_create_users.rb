class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string        :name,    :limit => 100, :default => '', :null => true
      t.string        :email,   :limit => 100
      t.string        :login, :crypted_password, :salt, :activation_code, :remember_token, :limit => 40
      t.string        :state,   :null => :no, :default => 'passive'
      t.datetime      :activated_at, :deleted_at, :visited_at, :remember_token_expires_at
      
      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end