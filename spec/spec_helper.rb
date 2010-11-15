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
    "sudo_attr_protected :name",
    "sudo_attr_accessible :color, :age",
    "attr_protected :name; sudo_attr_protected"
  ]
  
  def self.build_cat_class(argument)

    # Remove the Cat class if it's already been defined in previous run
    Object.class_eval { remove_const "Cat" if const_defined? "Cat" }

    # Create a new Cat class and evaluate 'has_sudo_attributes :arguments
    klass = Class.new(ActiveRecord::Base)
    Object.const_set("Cat", klass)

    Cat.class_eval %{
      validates_presence_of :color
      #{argument}
    }
  end
end
