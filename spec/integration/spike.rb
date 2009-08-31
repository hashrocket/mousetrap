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
  all_customers = Mousetrap::Customer.all
  puts all_customers.to_yaml
  all_customers.each { |c| c.destroy }

  customer = Factory :new_customer
  customer.save

  api_customer = Mousetrap::Customer[customer.code]
  puts api_customer.to_yaml

  all_customers = Mousetrap::Customer.all
  puts all_customers.to_yaml
end

customers





__END__



all_customers = Mousetrap::Customer.all
puts all_customers.inspect
puts all_customers.to_yaml


code = 'maasdxgliu@example.com'
c = Mousetrap::Customer[code]
puts c.to_yaml
c.destroy

puts '-' * 80
c = Mousetrap::Customer[code]
puts c.to_yaml





email = random_email_address
attributes = {
  'code' => email,
  'firstName' => 'Example',
  'lastName' => 'Customer',
  'email' => email,
  'subscription' => {
      'planCode' => 'TEST',
      'ccFirstName' => 'Jon',
      'ccLastName' => 'Larkowski',
      'ccNumber' => '4111111111111111',
      'ccExpiration' => '12-2012',
      'ccZip' => '90210'
  }
}

customer = Mousetrap::Customer.create attributes
puts customer




customers_hash = Mousetrap::Customer['maasdxgliu@example.com']
customer_hash = customers_hash['customers']['customer'].slice 'firstName', 'lastName', 'email', 'code'
customer = Mousetrap::Customer.new customer_hash

customer.first_name = random_string
puts customer.save!

