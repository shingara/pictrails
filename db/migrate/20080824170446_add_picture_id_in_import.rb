class AddPictureIdInImport < ActiveRecord::Migration
  def self.up
    add_column 'imports', 'picture_id', :integer
    add_column 'imports', 'type_pic', :integer
  end

  def self.down
    remove_column 'imports', 'picture_id'
    remove_column 'imports', 'type_pic'
  end
end
