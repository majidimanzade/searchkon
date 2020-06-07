$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'searchkon'
require 'active_record'
require 'active_support'
require 'active_support/core_ext'
require 'rspec'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load File.dirname(__FILE__) + '/schema.rb'
require File.dirname(__FILE__) + '/models/coupon.rb'
require File.dirname(__FILE__) + '/models/payment.rb'
require File.dirname(__FILE__) + '/models/product.rb'