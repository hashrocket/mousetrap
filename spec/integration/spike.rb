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

def all_customers
  all_customers = Mousetrap::Customer.all
  puts all_customers.to_yaml
end

def create_customer
  customer = Factory :new_customer
  customer.save

  api_customer = Mousetrap::Customer[customer.code]
  puts api_customer.to_yaml
end

def destroy_all_customers
  Mousetrap::Customer.destroy_all
end
#create_customer

destroy_all_customers
customer = Factory :new_customer
customer.save

api_customer = Mousetrap::Customer[customer.code]
puts api_customer.to_yaml
puts '-' * 80

Mousetrap::Subscription.update customer.code, {
  :billing_first_name => 'x',
  :billing_last_name => 'y',
  :credit_card_number => '5555555555554444',
  :credit_card_expiration_month => '05',
  :credit_card_expiration_year => '2013',
  :billing_zip_code => '31415'
}

api_customer = Mousetrap::Customer[customer.code]
puts api_customer.to_yaml
puts '-' * 80

#customer_only_fields = Mousetrap::Customer.new \
  #:first_name => 'first',
  #:last_name => 'last',
  #:company => 'company',
  #:email => 'random@example.com',
  #:code => customer.code

#customer_only_fields.save

#api_customer = Mousetrap::Customer[customer.code]
#puts api_customer.to_yaml


#code = "rvhljmvenp@example.com"
#api_customer = Mousetrap::Customer[code]
##puts api_customer.to_yaml

#customer = Factory :new_customer
#customer.save
#api_customer = Mousetrap::Customer[customer.code]

#puts '-' * 80
#p Mousetrap::Customer[customer.code]

#puts '-' * 80
#p Mousetrap::Customer.exists? customer.code

#puts '-' * 80
#p Mousetrap::Customer['cantfindme']

#puts '-' * 80
#p Mousetrap::Customer.exists? 'cantfindme'

# create_customer

#code = 'igcuvfehrc@example.com'
#api_customer = Mousetrap::Customer[code]
#puts api_customer.to_yaml
#puts '-' * 80
#puts 'cancel'
#puts api_customer.cancel
#puts '-' * 80
#api_customer = Mousetrap::Customer[code]
#puts api_customer.to_yaml


