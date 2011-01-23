require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


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

          it "should not raise an error with sudo_update_attributes" do
            lambda { @cat.sudo_update_attributes(:color => "") }.should_not raise_error(ActiveRecord::RecordInvalid)
          end

          it "should set the name with sudo_update_attributes!" do
            @cat.sudo_update_attributes!(:name => "Smiles")
            @cat.name.should == "Smiles"
          end

          it "should raise an error with sudo_update_attributes!" do
            lambda { @cat.sudo_update_attributes!(:color => "") }.should raise_error(ActiveRecord::RecordInvalid)
          end

          it "should have a color" do
            @cat.color.should == @attributes[:color]
          end
          
          it "should have an age" do
            @cat.age.should == @attributes[:age]
          end
        
        end

        # Tests for sudo_new and sudo_build, aliases of each other
        [:sudo_new, :sudo_build].each do |sudo_method|

          context "SudoAttributes #{sudo_method} initializer" do
            before(:each) { @cat = Cat.send(sudo_method, @attributes)}

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

describe "A Cat" do

  before(:each) do
    SudoAttributesTest::build_cat_class("sudo_attr_protected :name")
  end

  context "when initialized with invalid params using sudo_create!" do

    it "should raise an ActiveRecord exception" do
      begin
        Cat.sudo_create! :name => "Smiles", :age => 12
        true.should == false
      rescue ActiveRecord::RecordInvalid
        true.should == true
      end
    end
  end

  context "when initialized with valid params using sudo_create!" do
    it "should not raise an ActiveRecord exception" do
      begin
        Cat.sudo_create! :name => "Smiles", :color => "gray", :age => 12
        true.should == true
      rescue ActiveRecord::RecordInvalid
        true.should == false
      end
    end

    it "should have a name" do
      @cat = Cat.sudo_create! :name => "Smiles", :color => "gray", :age => 12
      @cat.name.should == "Smiles"
    end
  end
end
