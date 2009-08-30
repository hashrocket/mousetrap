$LOAD_PATH.unshift(File.dirname(__FILE__))

begin; require 'rubygems'; rescue LoadError; end
require 'httparty'

module Mousetrap
  autoload(:Customer, 'mousetrap/customer')
  autoload(:Plan, 'mousetrap/plan')
  autoload(:Resource, 'mousetrap/resource')

  class << self
    attr_accessor :product_code

    def authenticate(user, password)
      Resource.basic_auth user, password
    end
  end
end
