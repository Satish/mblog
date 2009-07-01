class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text        :body, :default => ''
      t.references  :parent, :owner
      t.references  :attachable, :polymorphic => true
      t.integer     :lft, :rgt
      t.datetime    :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
