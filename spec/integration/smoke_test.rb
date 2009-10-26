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

    it "And I should see company" do
      @api_customer.company.should == @customer.company
    end

    it "And I should see the code" do
      @api_customer.code.should == @customer.code
    end

    it "And I should see the ID" do
      @api_customer.id.should == @customer.id
    end
  end
end

shared_examples_for "an active Subscription record from CheddarGetter" do
  describe "And I get the subscription" do
    before :all do
      @api_customer = Mousetrap::Customer[@customer.code]
      @api_subscription = @api_customer.subscription
    end

    it "Then ID is set" do
      @api_subscription.id.should be
    end

    it "Then canceled_at is not set" do
      @api_subscription.canceled_at.should be_nil
    end

    it "Then created_at is set" do
      @api_subscription.created_at.should be
    end

    it "Then I should see the credit card expiration" do
      expiration_date_from_api = Date.parse(@api_subscription.credit_card_expiration_date)
      expiration_date = Date.parse("#{@customer.subscription.credit_card_expiration_year}-#{@customer.subscription.credit_card_expiration_month}-31")
      expiration_date_from_api.should == expiration_date
    end

    it "Then I should see the credit card last four digits" do
      @api_subscription.credit_card_last_four_digits.should == @customer.subscription.credit_card_number[-4..-1]
    end

    it "Then I should see the credit card type" do
      @api_subscription.credit_card_type.should == (@credit_card_type || 'visa')
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
        it_should_behave_like "an active Subscription record from CheddarGetter"
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

    describe ".update" do
      describe "Given a customer" do
        before :all do
          @customer = Factory :new_customer
          @api_customer = nil

          # TODO: figure out why multiple records are being created even though
          # we use "before :all".  Until then, here's the kludge...
          if Mousetrap::Customer.all.size == 1
            @api_customer = Mousetrap::Customer.all.first
            @customer = @api_customer
          else
            @customer.save
            @api_customer = Mousetrap::Customer[@customer.code]
          end
        end

        describe "When I update the customer, with only customer attributes" do
          before :all do
            @api_customer = Mousetrap::Customer[@customer.code]

            updated_attributes = {
              :first_name => 'new_first',
              :last_name => 'new_last',
              :email => 'new_email@example.com',
              :company => 'new_company'
            }

            @customer = Mousetrap::Customer.new updated_attributes
            @customer.code = @api_customer.code
            @customer.id = @api_customer.id

            Mousetrap::Customer.update(@api_customer.code, updated_attributes)
          end

          it_should_behave_like "a Customer record from CheddarGetter"
        end

        describe "When I update the customer, with customer and subscription attributes" do
          before :all do
            @api_customer = Mousetrap::Customer[@customer.code]

            updated_attributes = {
              :first_name => 'new_first',
              :last_name => 'new_last',
              :email => 'new_email@example.com',
              :company => 'new_company',
              :subscription_attributes => {
                :plan_code                    => 'TEST',
                :billing_first_name           => 'new_billing_first',
                :billing_last_name            => 'new_billing_last',
                :credit_card_number           => '5555555555554444',
                :credit_card_expiration_month => '01',
                :credit_card_expiration_year  => '2013',
                :billing_zip_code             => '12345'
              }
            }

            @credit_card_type = 'mc'

            @customer = Mousetrap::Customer.new updated_attributes

            # set up our test comparison objects as if they came from API gets
            @customer.code = @api_customer.code
            @customer.id = @api_customer.id
            @customer.subscription.send(:id=, @api_customer.subscription.id)

            Mousetrap::Customer.update(@api_customer.code, updated_attributes)
          end

          it_should_behave_like "a Customer record from CheddarGetter"
          it_should_behave_like "an active Subscription record from CheddarGetter"
        end
      end
    end

    describe "#cancel" do
      describe "Given a customer" do
        before :all do
          @customer = Factory :new_customer
          @api_customer = nil

          if Mousetrap::Customer.all.size == 1
            @api_customer = Mousetrap::Customer.all.first
            @customer = @api_customer
          else
            @customer.save
            @api_customer = Mousetrap::Customer[@customer.code]
          end
        end

        describe "When I cancel" do
          before :all do
            @api_customer.cancel
          end

          describe "And I get the customer" do
            before :all do
              @api_customer = Mousetrap::Customer[@customer.code]
            end

            it "Then I should see a cancellation date on subscription" do
              @api_customer.subscription.canceled_at.should be
            end

            describe "When I resubscribe them" do
              before :all do
                @customer = Factory :new_customer, :email => @api_customer.email, :code => @api_customer.email
                @customer.save
              end

              it_should_behave_like "a Customer record from CheddarGetter"
              it_should_behave_like "an active Subscription record from CheddarGetter"
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

        describe "When I save it again, with different attributes" do
          before :all do
            attributes = Factory.attributes_for :new_customer
            @customer.first_name = attributes[:first_name]
            @customer.last_name = attributes[:last_name]
            @customer.email = attributes[:email]
            @customer.company = attributes[:company]
            @customer.save
          end

          it_should_behave_like "a Customer record from CheddarGetter"
        end

        context "When I update subscription information" do
          before :all do
            @subscription = Mousetrap::Subscription.new(Factory.attributes_for(:alternate_subscription))
            @credit_card_type = 'mc'
            @customer.subscription = @subscription
            @customer.save
          end

          it_should_behave_like "an active Subscription record from CheddarGetter"
        end
      end
    end

    describe '#switch_to_plan' do
      describe "Given an existing CheddarGetter customer" do
        before :all do
          @customer = Factory :new_customer
          @customer.save
        end

        describe 'When I switch plans' do
          before :all do
            @customer.switch_to_plan('TEST_2')
          end

          describe "And I get the customer" do
            before :all do
              @api_customer = Mousetrap::Customer[@customer.code]
            end

            it 'Then they should be on the new plan' do
              @api_customer.subscription.plan.code.should == 'TEST_2'
            end
          end
        end
      end
    end
  end

  describe Mousetrap::Subscription do
    describe "Given a customer on CheddarGetter" do
      before :all do
        @customer = Factory :new_customer
        violated "Use a visa for setup" unless @customer.subscription.credit_card_number == '4111111111111111'
        @customer.save
      end

      describe "When I update a subscription field" do
        before :all do
          Mousetrap::Subscription.update @customer.code, :credit_card_number => '5555555555554444'
        end

        describe "And I get the customer" do
          before :all do
            @api_customer = Mousetrap::Customer[@customer.code]
          end

          it 'Then I should see the updated field' do
            @api_customer.subscription.credit_card_last_four_digits.should == '4444'
          end
        end
      end
    end
  end
end
