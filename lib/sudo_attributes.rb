module SudoAttributes
  extend ActiveSupport::Concern

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
      instance.assign_attributes(attributes, :without_protection => true)
      instance
    end

    alias sudo_build sudo_new

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
      assign_attributes(new_attributes, :without_protection => true)
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
      assign_attributes(new_attributes, :without_protection => true)
      save!
    end
  end
end

ActiveRecord::Base.send(:include, SudoAttributes)
