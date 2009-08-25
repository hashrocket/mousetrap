require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pp'

describe "The System" do
  before do
    settings = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')
    Mousetrap.authenticate(settings['user'], settings['password'])
    Mousetrap.product_code = settings['product_code']
  end

  it 'Customer.all' do
    puts Mousetrap::Customer.all.to_yaml
  end

  it "Customer.create" do
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
  end
end
