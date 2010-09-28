module SudoAttributes
  
  module InstanceMethods
    def sudo_update_attributes(new_attributes)
      self.send(:attributes=, new_attributes, false)
      save
    end
  end
  
  module ClassMethods
    
    # protected_attributes    
    def sudo_attr_protected(protected_attrs=nil)
      self.attr_protected *protected_attrs unless protected_attrs.nil?
      add_initialize(self)
    end
    
    def sudo_attr_accessible(accessible_attrs=nil)
      self.attr_accessible *accessible_attrs unless accessible_attrs.nil?
      add_initialize(self)
    end
    
    def sudo_create(attributes=nil)
      instance = sudo_new(attributes)
      instance.save
      instance
    end
    
    def sudo_new(attributes=nil)
      new(attributes, false)
    end
    
    private
    
    def add_initialize(klass)
      klass.class_eval do
        def initialize(attributes=nil, attributes_protected=true)
          super(nil)
          send(:attributes=, attributes, attributes_protected)
        end
      end
    end
  
  end  
end

ActiveRecord::Base.send :extend, SudoAttributes::ClassMethods
ActiveRecord::Base.send :include, SudoAttributes::InstanceMethods