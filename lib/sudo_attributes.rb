module SudoAttributes
  module ClassMethods
    # Creates an object (or multiple objects) with protected attributes and saves it to the database, if validations pass.
    # The resulting object is returned whether the object was saved successfully to the database or not.
    #
    # The +attributes+ parameter can be either be a Hash or an Array of Hashes. These Hashes describe the
    # attributes on the objects that are to be created.
    #
    # ==== Examples
    #   # Create a single new object
    #   User.sudo_create(:first_name => 'Pete')
    #
    #   # Create an Array of new objects
    #   User.sudo_create([{ :first_name => 'Pete' }, { :first_name => 'Sebastian' }])
    #
    #   # Create a single object and pass it into a block to set other attributes.
    #   User.sudo_create(:first_name => 'Pete') do |u|
    #     u.is_admin = false
    #   end
    #
    #   # Creating an Array of new objects using a block, where the block is executed for each object:
    #   User.sudo_create([{ :first_name => 'Pete' }, { :first_name => 'Sebastian' }]) do |u|
    #     u.is_admin = false
    #   end
    def sudo_create(attributes = nil, &block)
      if attributes.is_a?(Array)
        attributes.collect { |attr| sudo_create(attr, &block) }
      else
        object = sudo_new(attributes)
        yield(object) if block_given?
        object.save
        object
      end
    end

    # Creates an object just like sudo_create but calls save! instead of save so an exception is raised if the record is invalid
    #
    # ==== Example
    #   # Create a single new object where admin is a protected attribute
    #   User.sudo_create!(:first_name => 'Pete', :admin => true)
    def sudo_create!(attributes = nil, &block)
      if attributes.is_a?(Array)
        attributes.collect { |attr| sudo_create!(attr, &block) }
      else
        object = sudo_new(attributes)
        yield(object) if block_given?
        object.save!
        object
      end
    end

    # Instantiates an object just like ActiveRecord::Base.new, but allowing mass assignment of protected attributes
    #
    # ==== Example
    #   # Instantiate an object where admin is a protected attribute
    #   User.sudo_new(:first_name => 'Pete', :admin => true)
    def sudo_new(attributes = nil)
      instance = new(nil)
      instance.sudo_assign_attributes(attributes)
      instance
    end

    alias sudo_build sudo_new

  end

  module InstanceMethods

    # Updates attributes of a model, including protected ones, from the passed-in hash and saves the
    # record. If the object is invalid, the saving will fail and false will be returned.
    #
    # ==== Example
    #   # Updated protected attributes on an instance of User
    #   @user = User.find(params[:id])
    #   @user.sudo_update_attributes(params[:user])
    def sudo_update_attributes(new_attributes)
      sudo_assign_attributes(new_attributes)
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
      sudo_assign_attributes(new_attributes)
      save!
    end

    # Used by sudo_attributes internally as a common API between Rails 3 and 3.1
    def sudo_assign_attributes(attributes)
      if respond_to? :assign_attributes
        assign_attributes(attributes, :without_protection => true)
      else
        self.send(:attributes=, attributes, false)
      end
    end
  end
end

ActiveRecord::Base.send(:include, SudoAttributes::InstanceMethods)
ActiveRecord::Base.extend SudoAttributes::ClassMethods
