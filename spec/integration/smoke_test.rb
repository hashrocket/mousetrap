require File.dirname(__FILE__) + '/../../lib/mousetrap'
require 'yaml'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/../support/**/*.rb"].each {|f| require f}

settings = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')
Mousetrap.authenticate(settings['user'], settings['password'])
Mousetrap.product_code = settings['product_code']

puts Mousetrap::Customer['maasdxgliu@example.com'].to_yaml

puts Mousetrap::Plan['TEST'].to_yaml
puts Mousetrap::Plan.all.to_yaml


__END__
puts Mousetrap::Customer.all.to_yaml

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
