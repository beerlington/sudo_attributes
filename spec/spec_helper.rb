$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'active_record'
require 'sudo_attributes'
require 'spec' 

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :cats, :force => true do |t|
    t.string :name
    t.string :color
    t.integer :age
  end
end

module SudoAttributesTest
  ARGUMENTS = [
    { :protected => :name},
    { :accessible => [:color, :age] },
    :name,
    nil # No arguments passed in
  ]
  
  def self.build_cat_class(arguments)

    # Remove the Cat class if it's already been defined in previous run
    Object.class_eval { remove_const "Cat" if const_defined? "Cat" }

    # Create a new Cat class and evaluate 'has_sudo_attributes :arguments
    klass = Class.new(ActiveRecord::Base)
    Object.const_set("Cat", klass)

    if arguments.nil? 
      Cat.class_eval do
        attr_protected :name
        has_sudo_attributes
      end
    else
      Cat.class_eval do
        validates_presence_of :color
        has_sudo_attributes arguments
      end
    end
  end
end
