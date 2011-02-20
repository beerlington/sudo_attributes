module SudoAttributes

  module Base

    # Protect attributes using ActiveRecord's built in <tt>attr_protected</tt> class macro.
    # When invoked, it also adds other sudo_attributes class and instance methods to model such as +sudo_create+
    #
    # ==== Example
    #   # Define attributes which are protected from mass assignment
    #   class User < ActiveRecord::Base
    #     sudo_attr_protected :admin
    #   end
    def sudo_attr_protected(*attrs)
      Private::set_attributes(self, attrs, :protected)
    end

    # Protect attributes using ActiveRecord's built in <tt>attr_accessible</tt> class macro.
    # When invoked, it also adds other sudo_attributes class and instance methods to model such as +sudo_create+
    #
    # ==== Example
    #   # Define attributes which are not protected from mass assignment
    #   class User < ActiveRecord::Base
    #     sudo_attr_accessible :admin
    #   end
    def sudo_attr_accessible(*attrs)
      Private::set_attributes(self, attrs, :accessible)
    end
  end

  module Private # :nodoc: all

    # Used internally to assign protected attributes and include additional sudo_attributes functionality
    def self.set_attributes(klass, attrs, type)
      # Call attr_(accessible|protected) if attributes are passed in
      klass.send("attr_#{type}", *attrs) unless attrs.empty?

      klass.extend SudoAttributes::ClassMethods
      klass.send :include, SudoAttributes::InstanceMethods
    end
  end

  # Added to ActiveRecord model only if sudo_attr_(accessible|protected) is called
  module ClassMethods
    # Creates an object with protected attributes and saves it to the database, if validations pass.
    # The resulting object is returned whether the object was saved successfully to the database or not.
    #
    # Unlike ActiveRecord::Base.create, the <tt>attributes</tt> parameter can only be a Hash. This Hash describes the
    # attributes on the objects that are to be created.
    #
    # ==== Example
    #   # Create a single new object where admin is a protected attribute
    #   User.sudo_create(:first_name => 'Pete', :admin => true)
    def sudo_create(attributes=nil)
      instance = sudo_new(attributes)
      instance.save
      instance
    end

    # Creates an object just like sudo_create but calls save! instead of save so an exception is raised if the record is invalid
    #
    # ==== Example
    #   # Create a single new object where admin is a protected attribute
    #   User.sudo_create!(:first_name => 'Pete', :admin => true)
    def sudo_create!(attributes=nil)
      instance = sudo_new(attributes)
      instance.save!
      instance
    end

    # Instantiates an object just like ActiveRecord::Base.new, but allowing mass assignment of protected attributes
    #
    # ==== Example
    #   # Instantiate an object where admin is a protected attribute
    #   User.sudo_new(:first_name => 'Pete', :admin => true)
    def sudo_new(attributes=nil)
      instance = new(nil)
      instance.send(:attributes=, attributes, false)
      instance
    end

    # Alias of +sudo_new+
    def sudo_build(attributes=nil)
      sudo_new(attributes)
    end
  end

  # Added to ActiveRecord model only if sudo_attr_(accessible|protected) is called
  module InstanceMethods

    # Updates attributes of a model, including protected ones, from the passed-in hash and saves the
    # record. If the object is invalid, the saving will fail and false will be returned.
    #
    # ==== Example
    #   # Updated protected attributes on an instance of User
    #   @user = User.find(params[:id])
    #   @user.sudo_update_attributes(params[:user])
    def sudo_update_attributes(new_attributes)
      self.send(:attributes=, new_attributes, false)
      save
    end

    # Updates its receiver just like +sudo_update_attributes+ but calls <tt>save!</tt> instead
    # of +save+, so an exception is raised if the record is invalid.
    #
    # ==== Example
    #   # Updated protected attributes on an instance of User
    #   @user = User.find(params[:id])
    #   @user.sudo_update_attributes!(params[:user])
    def sudo_update_attributes!(new_attributes)
      self.send(:attributes=, new_attributes, false)
      save!
    end
  end
end

ActiveRecord::Base.extend SudoAttributes::Base
