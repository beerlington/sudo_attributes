module SudoAttributes

  module Base
    def sudo_attr_protected(*attrs)
      Private::set_attributes(self, attrs, :protected)
    end

    def sudo_attr_accessible(*attrs)
      Private::set_attributes(self, attrs, :accessible)
    end
  end

  module Private

    def self.set_attributes(klass, attrs, type)
      unless attrs.empty?
        raise "Invalid argument passed to has_sudo_attributes" unless attrs.all? {|a| a.is_a? Symbol }

        klass.send("attr_#{type}", *attrs)
      end

      klass.extend SudoAttributes::ClassMethods
      klass.send :include, SudoAttributes::InstanceMethods
    end
  end
  
  # Added to ActiveRecord model only if has_sudo_attributes is called
  module ClassMethods
    def sudo_create(attributes=nil)
      instance = sudo_new(attributes)
      instance.save
      instance
    end

    def sudo_create!(attributes=nil)
      instance = sudo_new(attributes)
      instance.save!
      instance
    end

    def sudo_new(attributes=nil)
      instance = new(nil)
      instance.send(:attributes=, attributes, false)
      instance
    end
  end
 
  module InstanceMethods
    def sudo_update_attributes(new_attributes)
      self.send(:attributes=, new_attributes, false)
      save
    end
  end
end

ActiveRecord::Base.extend SudoAttributes::Base
