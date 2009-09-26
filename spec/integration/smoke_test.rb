require File.expand_path('../../../lib/mousetrap', __FILE__)

require 'spec'
require 'spec/autorun'
require 'factory_girl'
require 'active_support'
require 'yaml'

Dir["#{File.dirname(__FILE__)}/../support/**/*.rb"].each {|f| require f}

settings = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')
Mousetrap.authenticate(settings['user'], settings['password'])
Mousetrap.product_code = settings['product_code']

Spec::Runner.configure do |config|
  config.before :suite do
    begin
      Mousetrap::Customer.destroy_all
    rescue
    end
  end
end

describe "The Wrapper Gem" do
  describe Mousetrap::Customer do
    describe "#cancel" do
      describe "Given a customer" do
        before :all do
          @customer = Factory :new_customer
          @customer.save
          @api_customer = Mousetrap::Customer[@customer.code]
        end

        describe "When I cancel" do
          before :all do
            @api_customer.cancel
          end

          describe "And I get the customer" do
            before :all do
              @api_customer = Mousetrap::Customer[@customer.code]
            end

            it "Then I should see a cancelation date on subscription" do
              @api_customer.subscription.canceled_at.should be
            end
          end
        end
      end
    end
  end
end
