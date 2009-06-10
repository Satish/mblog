class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :filename, :content_type, :thumbnail
      t.integer :size, :width, :height
      t.references :parent, :owner
      t.references :attachable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
