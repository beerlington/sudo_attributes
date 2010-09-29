require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
      Cat.class_eval { has_sudo_attributes arguments }
    end
  end
end

describe "Cat" do
  
  SudoAttributesTest::ARGUMENTS.each do |arguments|
    
    SudoAttributesTest::build_cat_class(arguments)
    
    context "calling has_sudo_attributes #{arguments.inspect}" do
      
      before(:all) do
        @attributes = {:name => "Smiles", :color => "gray", :age => 6}
      end

      context "that is built using" do

        context "default rails initializer" do
          before(:each) { @cat = Cat.new @attributes}

          it "should not have a name" do
            @cat.name.should be_nil
          end
          
          it "should not set the name with update_attributes" do
            @cat.update_attributes(:name => "Smiles")
            @cat.name.should be_nil
          end
          
          it "should set the name with sudo_update_attributes" do
            @cat.sudo_update_attributes(:name => "Smiles")
            @cat.name.should == "Smiles"
          end

          it "should have a color" do
            @cat.color.should == @attributes[:color]
          end
          
          it "should have an age" do
            @cat.age.should == @attributes[:age]
          end
        
        end

        context "SudoAttributes sudo_new initializer" do
          before(:each) { @cat = Cat.sudo_new @attributes}

          it "should have a name" do
            @cat.name.should == @attributes[:name]
          end
          
          it "should set the name with sudo_update_attributes" do
            @cat.sudo_update_attributes(:name => "Portia")
            @cat.name.should == "Portia"
          end

          it "should have a color" do
            @cat.color.should == @attributes[:color]
          end

          it "should not have an id" do
            @cat.id.should be_nil
          end
          
          it "should have an age" do
            @cat.age.should == @attributes[:age]
          end
        end

        context "SudoAttributes sudo_create initializer" do
          before(:each) { @cat = Cat.sudo_create @attributes}

          it "should have a name" do
            @cat.name.should == @attributes[:name]
          end
          
          it "should set the name with sudo_update_attributes" do
            @cat.sudo_update_attributes(:name => "Portia")
            @cat.name.should == "Portia"
          end

          it "should have a color" do
            @cat.color.should == @attributes[:color]
          end

          it "should have an id" do
            @cat.id.should_not be_nil
          end
          
          it "should have an age" do
            @cat.age.should == @attributes[:age]
          end
        end
      end
    end
  end
end