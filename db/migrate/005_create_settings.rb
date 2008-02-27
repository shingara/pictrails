class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.text 'settings'
    end
    Setting.new.save
  end

  def self.down
    drop_table :settings
  end
end
