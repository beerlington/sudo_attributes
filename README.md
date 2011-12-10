# sudo_attributes

[![Build Status](https://secure.travis-ci.org/beerlington/sudo_attributes.png?branch=master)](http://travis-ci.org/beerlington/sudo_attributes)

Adds 'sudo' methods to active record classes, allowing you to easily override protected attributes.

## Requirements

*Rails:* Any version of Rails 2.3.x or Rails 3.x. (Older versions of Rails may work, but have not been tested)

## Installation

The gem is hosted at [rubygems.org](https://rubygems.org/gems/sudo_attributes) and can be installed with: `gem install sudo_attributes`

## The Problem

ActiveModel provides a convenient way to make your application more secure by using "protected" attributes. Protected attributes are assigned using either `attr_protected` or `attr_accessible`. This adds security by preventing mass assignment of attributes when doing things like `user.update_attributes(params[:user])`. The issue is that it can be tedious to always manually assign protected attributes in an administrative area of your application. You may find yourself doing things like:

```ruby
user = User.find(params[:id])
user.update_attributes(params[:user])
user.admin = true
user.something_else = true
user.save
```

or the alternative in Rails 3.1:

```ruby
user.assign_attributes(params[:user], :without_protection => true)
user.save
```

## The Solution

SudoAttributes adds a few 'sudo' methods to your models, allowing you to override the protected attributes **when you know the input can be trusted**.

```ruby
class User < ActiveRecord::Base
  attr_protected :admin
end

user = User.find(params[:id])
user.sudo_update_attributes(params[:user])
```

## Class Methods

`Model.sudo_create` - Uses same syntax as `Model.create` to instantiate and save an object with protected attributes

`Model.sudo_create!` - Similar to `Model.sudo_create`, but it raises an ActiveRecord::RecordInvalid exception if there are invalid attributes

`Model.sudo_new` - Uses same syntax as `Model.new` to instantiate, but not save an object with protected attributes

## Instance Methods

`sudo_update_attributes` - Uses identical syntax to `update_attributes`, but overrides protected attributes.

`sudo_update_attributes!` - Same as sudo_update_attributes, but raises ActiveRecord errors. Same as `update_attributes!`

## Examples

**Protect an admin boolean attribute**

```ruby
class User < ActiveRecord::Base
  attr_protected :admin
end
```

In your admin controller...

```ruby
params[:user] = {:name => "Pete", :admin => true} (Typically set from a form)

@user = User.sudo_create(params[:user])

Somewhere else in your admin controller...

params[:user] = {:admin => false, :name => "Pete"}

@user.sudo_update_attributes(params[:user])
```

## Copyright

Copyright (c) 2011 [Peter Brown](https://github.com/beerlington). See LICENSE for details.
