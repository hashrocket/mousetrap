require File.dirname(__FILE__) + '/../../lib/mousetrap'
require 'yaml'
require 'activesupport'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/../support/**/*.rb"].each {|f| require f}

settings = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')
Mousetrap.authenticate(settings['user'], settings['password'])
Mousetrap.product_code = settings['product_code']

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



__END__

puts Mousetrap::Plan.all.to_yaml
puts Mousetrap::Customer['maasdxgliu@example.com'].to_yaml
puts Mousetrap::Plan['TEST'].to_yaml
puts Mousetrap::Customer.all.to_yaml


customers_hash = Mousetrap::Customer['maasdxgliu@example.com']
customer_hash = customers_hash['customers']['customer'].slice 'firstName', 'lastName', 'email', 'code'
customer = Mousetrap::Customer.new customer_hash

customer.first_name = random_string
puts customer.save!

customer_hash = Mousetrap::Customer['maasdxgliu@example.com']
puts customer_hash.to_yaml

