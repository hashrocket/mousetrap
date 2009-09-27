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

shared_examples_for "a Customer record from CheddarGetter" do
  describe "And I get the customer" do
    before :all do
      @api_customer = Mousetrap::Customer[@customer.code]
    end

    it "Then I should see first name" do
      @api_customer.first_name.should == @customer.first_name
    end

    it "And I should see last name" do
      @api_customer.last_name.should == @customer.last_name
    end

    it "And I should see the code" do
      @api_customer.code.should == @customer.code
    end

    it "And I should see the ID" do
      @api_customer.id.should == @customer.id
    end
  end
end

describe "The Wrapper Gem" do
  describe Mousetrap::Customer do
    describe ".all" do
      describe "Given a few customers on CheddarGetter" do
        before :all do
          3.times { Factory(:new_customer).save }
          violated "Couldn't save customers" unless Mousetrap::Customer.all.size == 3
        end

        describe "When I call .all" do
          before :all do
            @all_customers = Mousetrap::Customer.all
          end

          it "Then I should get all the customers" do
            @all_customers.size.should == 3
          end
        end
      end
    end

    describe ".create" do
      describe "When I create a customer" do
        before :all do
          attributes = Factory.attributes_for :new_customer
          @customer = Mousetrap::Customer.create attributes
        end

        it_should_behave_like "a Customer record from CheddarGetter"
      end
    end

    describe ".destroy_all" do
      describe "Given a few customers on CheddarGetter" do
        before :all do
          Mousetrap::Customer.destroy_all
          3.times { Factory(:new_customer).save }
          violated "Couldn't save customers" unless Mousetrap::Customer.all.size == 3
        end

        describe "When I call .destroy_all" do
          before :all do
            Mousetrap::Customer.destroy_all
          end

          it "Then there should be no customers" do
            Mousetrap::Customer.all.size.should == 0
          end
        end
      end
    end

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

    describe "#save" do
      describe "When I save a customer" do
        before :all do
          @customer = Factory :new_customer
          @customer.save
        end

        it_should_behave_like "a Customer record from CheddarGetter"

        describe "And I save it again, with different attributes" do
          before :all do
            attributes = Factory.attributes_for :new_customer
            @customer.first_name = attributes[:first_name]
            @customer.last_name = attributes[:last_name]
            @customer.email = attributes[:email]
            @customer.save
          end

          it_should_behave_like "a Customer record from CheddarGetter"
        end
      end
    end
  end
end
