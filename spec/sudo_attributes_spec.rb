require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Cat" do
  let(:attributes) { {:name => "Smiles", :color => "gray", :age => 6} }

  context "default rails initializer" do
    let(:cat) { Cat.new(attributes) }

    it "should not have a name" do
      cat.name.should be_nil
    end

    it "should not set the name with update_attributes" do
      cat.update_attributes(:name => "Smiles")
      cat.name.should be_nil
    end

    it "should set the name with sudo_update_attributes" do
      cat.sudo_update_attributes(:name => "Smiles")
      cat.name.should == "Smiles"
    end

    it "should not raise an error with sudo_update_attributes" do
      lambda { cat.sudo_update_attributes(:color => "") }.should_not raise_error(ActiveRecord::RecordInvalid)
    end

    it "should set the name with sudo_update_attributes!" do
      cat.sudo_update_attributes!(:name => "Smiles")
      cat.name.should == "Smiles"
    end

    it "should raise an error with sudo_update_attributes!" do
      lambda { cat.sudo_update_attributes!(:color => "") }.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should have a color" do
      cat.color.should eql('gray')
    end

    it "should have an age" do
      cat.age.should eql(6)
    end

  end

  # Tests for sudo_new and sudo_build, aliases of each other
  [:sudo_new, :sudo_build].each do |sudo_method|

    context "SudoAttributes #{sudo_method} initializer" do
      let(:cat) { Cat.send(sudo_method, attributes) }

      subject { cat }
      its(:name) { should eql('Smiles') }
      its(:color) { should eql('gray') }
      its(:id) { should be_nil }
      its(:age) { should eql(6) }

      it "should set the name with sudo_update_attributes" do
        cat.sudo_update_attributes(:name => "Portia")
        cat.name.should == "Portia"
      end

    end
  end

  context "SudoAttributes sudo_create initializer" do
    let(:cat) { Cat.sudo_create(attributes) }

    subject { cat }
    its(:name) { should eql('Smiles') }
    its(:color) { should eql('gray') }
    its(:id) { should_not be_nil }
    its(:age) { should eql(6) }

    it "should set the name with sudo_update_attributes" do
      cat.sudo_update_attributes(:name => "Portia")
      cat.name.should == "Portia"
    end

  end
end

describe "A Cat" do

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
      cat = Cat.sudo_create! :name => "Smiles", :color => "gray", :age => 12
      cat.name.should == "Smiles"
    end
  end
end
