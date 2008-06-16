module ConfigManager

  def self.append_features(base)
    super
    base.extend(ClassMethods)
  end


  module ClassMethods
   
    # Accessor of field.
    # @fields is a Hash if doesn't exist
    def fields
      @fields ||= Hash.new { Item.new }
    end

    # Made the setting into fields hash member value
    # All value become an accessor reader and writer
    # with name like methode name
    def setting(name, type=:object, default=nil)
      item = Item.new
      item.name, item.ruby_type, item.default = name.to_s, type, default
      fields[name.to_s] = item
      add_setting_accessor(item)
    end

    private

    # Made the item.name like an accessor
    def add_setting_accessor(item)
      add_setting_reader(item)
      add_setting_writer(item)
    end

    # Made the item.name like a reader
    def add_setting_reader(item)
      self.send(:define_method, item.name) do
        raw_value = settings[item.name]
        raw_value.nil? ? item.default : raw_value
      end
      if item.ruby_type == :boolean
        self.send(:define_method, item.name + "?") do
          raw_value = settings[item.name]
          raw_value.nil? ? item.default : raw_value
        end
      end
    end

    # Made the item.name like a writer
    def add_setting_writer(item)
      self.send(:define_method, "#{item.name}=") do |newvalue|
        retval = settings[item.name] = canonicalize(item.name, newvalue)
        unless new_record?
          self.settings_will_change!
          self.save
        end
        retval
      end
    end
  end

  def canonicalize(key, value)
    self.class.fields[key.to_s].canonicalize(value)
  end



  # Class Item. 
  # Manager an item save with his
  # type, the default value and his name
  class Item
    attr_accessor :name, :ruby_type, :default

    def canonicalize(value)
      case ruby_type
      when :boolean
        case value
        when "0", 0, '', false, "false", "f", nil
          false
        else
          true
        end
      when :integer
        value.to_i
      when :string
        value.to_s
      when :yaml
        value.to_yaml
      else
        value
      end
    end
  end

end
