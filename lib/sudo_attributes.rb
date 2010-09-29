module SudoAttributes
  
  module Base
    # This is the method that will be called from each model you want to enable SudoAttributes in
    def enable_sudo_attributes(attrs=nil)
      raise "Invalid argument passed to enable_sudo_attributes" unless valid_attributes? attrs

      set_protected_attributes(attrs) unless attrs.nil?

      self.send :extend, SudoAttributes::ClassMethods
      self.send :include, SudoAttributes::InstanceMethods
    end
    
    private
    
    # Validate that either nil, :protect, or :accessible has been given
    def valid_attributes?(attrs)
      attrs.nil? || (attrs.is_a?(Hash) && (attrs.has_key?(:protected) || attrs.has_key?(:accessible)))
    end

    # Set the protected attributes depending on the key
    def set_protected_attributes(attrs)
      key = attrs.has_key?(:protected) ? :protected : :accessible

      # Call either attr_protected or attr_accessible
      self.send("attr_#{key}", *attrs[key])
    end
  end
  
  # Added to ActiveRecord model only if enable_sudo_attributes is called
  module ClassMethods
    def sudo_create(attributes=nil)
      instance = sudo_new(attributes)
      instance.save
      instance
    end

    def sudo_new(attributes=nil)
      new(attributes, false)
    end
  end
 

  module InstanceMethods
    def initialize(attributes=nil, attributes_protected=true)
      super(nil)
      send(:attributes=, attributes, attributes_protected)
    end
    
    def sudo_update_attributes(new_attributes)
      self.send(:attributes=, new_attributes, false)
      save
    end
  end
end

ActiveRecord::Base.send :extend, SudoAttributes::Base
