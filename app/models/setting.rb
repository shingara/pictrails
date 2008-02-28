require 'lib/config_manager'
# Setting is the setting of one webapplication
# Maybe in futur, there are several webapp. I don't know
# the settings is save in a hash serializable in Database
class Setting < ActiveRecord::Base
  include ConfigManager
  serialize :settings, Hash

  setting :webapp_name,         :string, 'My own personal WebGallery'
  setting :webapp_subtitle,     :string, ''

  validate_on_update :validate_settings

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
  end

end
