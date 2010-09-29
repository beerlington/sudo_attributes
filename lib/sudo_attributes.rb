module SudoAttributes
  
  module Base
    # This is the method that will be called from each model you want to enable SudoAttributes in
    def has_sudo_attributes(*attrs)
      raise "Invalid argument passed to has_sudo_attributes" unless valid_attributes? attrs

      set_protected_attributes(attrs) unless attrs.empty?

      self.send :extend, SudoAttributes::ClassMethods
      self.send :include, SudoAttributes::InstanceMethods
    end
    
    private
    
    def valid_attributes?(attrs)
      attrs.empty? || hash_syntax?(attrs) || all_symbols?(attrs)
    end
    
    # True if argument is in the form ":protected => :field1" or ":accessible => :field2"
    def hash_syntax?(attrs)
      return false unless attrs.size == 1
  
      hash = attrs.first
      
      hash.is_a?(Hash) && (hash.has_key?(:protected) || hash.has_key?(:accessible))
    end
    
    # True if argument is in the form ":field1, :field2, :field3"
    def all_symbols?(attrs)
      attrs.all? {|e| e.class == Symbol}
    end

    # Set the protected attributes depending on the key
    def set_protected_attributes(attrs)
      if all_symbols? attrs
        self.attr_protected *attrs
      else
        key = attrs[0].has_key?(:protected) ? :protected : :accessible

        # Call either attr_protected or attr_accessible
        self.send("attr_#{key}", *attrs[0][key])
      end
    end
    
  end
  
  # Added to ActiveRecord model only if has_sudo_attributes is called
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
