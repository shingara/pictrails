class DeleteTimestampAndAddNumber < ActiveRecord::Migration
  def self.up
    remove_column :imports, :created_at
    remove_column :imports, :updated_at
    add_column :imports, :total, :integer
  end

  def self.down
    add_column :imports, :created_at, :date
    add_column :imports, :updated_at, :date
    remove_column :imports, :total
  end
end
