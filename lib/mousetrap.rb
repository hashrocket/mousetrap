$LOAD_PATH.unshift(File.dirname(__FILE__))

begin; require 'rubygems'; rescue LoadError; end
require 'httparty'

module Mousetrap
  autoload(:Resource, 'mousetrap/resource')
  autoload(:Customer, 'mousetrap/customer')
  
  class << self
    attr_accessor :product_code
    
    def authenticate(user, password)
      Resource.basic_auth user, password
    end
  end
end
