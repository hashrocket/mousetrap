# This script is for hacking and playing around.

require File.dirname(__FILE__) + '/../../lib/mousetrap'
require 'activesupport'
require 'factory_girl'
require 'ruby-debug'
require 'yaml'

Dir["#{File.dirname(__FILE__)}/../support/**/*.rb"].each {|f| require f}

settings = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')
Mousetrap.authenticate(settings['user'], settings['password'])
Mousetrap.product_code = settings['product_code']


def plans
  all_plans = Mousetrap::Plan.all
  puts all_plans.to_yaml

  test_plan = Mousetrap::Plan['TEST']
  puts test_plan.to_yaml
end

def customers
  customer = Factory :new_customer
  customer.save

  api_customer = Mousetrap::Customer[customer.code]
  puts api_customer.to_yaml

  #all_customers = Mousetrap::Customer.all
  #puts all_customers.to_yaml
end

def destroy_all_customers
  Mousetrap::Customer.destroy_all
end

destroy_all_customers
#customers
