require 'lib/config_manager'
# Setting is the setting of one webapplication
# Maybe in futur, there are several webapp. I don't know
# the settings is save in a hash serializable in Database
class Setting < ActiveRecord::Base
  include ConfigManager
  serialize :settings, Hash

  setting :webapp_name,         :string, 'My own personal WebGallery'
  setting :webapp_subtitle,     :string, ''

  def initialize
    super
    self.settings ||= {}
  end

  # Return the fist webapp by Id
  def self.default
    Setting.find :first, :order => 'id'
  end

end
