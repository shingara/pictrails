class CreateViewPicture < ActiveRecord::Migration
  def self.up
    Picture.all do |pic|
      unless File.exist?(File.join(RAILS_ROOT, 'public', pic.public_filename(:view)))
        File.cp(File.join(RAILS_ROOT, 'public', pic.public_filename), File.join(RAILS_ROOT, 'public', pic.public_filename(:view)))
      end
    end
  end

  def self.down
  end
end
