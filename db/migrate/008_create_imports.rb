class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.string  :path
      t.integer :gallery_id
      t.timestamps
    end

    add_index :imports, :gallery_id
  end

  def self.down
    drop_table :imports
  end
end
