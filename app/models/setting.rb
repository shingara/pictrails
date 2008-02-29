require 'lib/config_manager'
# Setting is the setting of one webapplication
# Maybe in futur, there are several webapp. I don't know
# the settings is save in a hash serializable in Database
class Setting < ActiveRecord::Base
  include ConfigManager
  serialize :settings, Hash

  setting :webapp_name,           :string, 'My own personal WebGallery'
  setting :webapp_subtitle,       :string, ''
  setting :thumbnail_max_width,   :string, '200'
  setting :thumbnail_max_height,  :string, '200'

  validate_on_update :validate_settings

  after_save :change_thumbnail_size

  def initialize
    super
    self.settings ||= {}
  end

  # Return the fist webapp by Id
  def self.default
    Setting.find :first, :order => 'id'
  end

private

  def validate_settings
    errors.add webapp_name, "Galleries names can't be blank" if webapp_name.empty?
    errors.add thumbnail_max_width, "The with max of a thumbnail can't be zero or negative" if thumbnail_max_width.to_i < 1
    errors.add thumbnail_max_height, "The height max of a thumbnail can't be zero or negative" if thumbnail_max_height.to_i < 1
  end

  # Change the thumbnails size of a Picture
  # with size define in setting
  def change_thumbnail_size
    Picture.has_attachment :thumbnails => { :thumb => "#{Setting.default.thumbnail_max_width}x#{Setting.default.thumbnail_max_height}>"}
  end

end
