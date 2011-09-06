$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rspec'
require 'active_record'
require 'sudo_attributes'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :cats, :force => true do |t|
    t.string :name
    t.string :color
    t.integer :age
  end
end

RSpec.configure do |config|
  config.color_enabled = true
end

class Cat < ActiveRecord::Base
  attr_protected :name
  validates_presence_of :color
end
