class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string    :title, :permalink
      t.text      :description
      t.boolean   :state,      :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
