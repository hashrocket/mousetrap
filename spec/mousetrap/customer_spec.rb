require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Customer do
  include Fixtures
  
  def customer_attributes_for_api(customer)
    {
      :firstName => customer.first_name,
      :lastName => customer.last_name,
      :email => customer.email,
      :company => customer.company,
      :code => customer.code,
      :subscription => {
        :planCode     => customer.subscription.plan_code,
        :ccFirstName  => customer.subscription.billing_first_name,
        :ccLastName   => customer.subscription.billing_last_name,
        :ccNumber     => customer.subscription.credit_card_number,
        :ccExpMonth   => customer.subscription.credit_card_expiration_month,
        :ccExpYear    => customer.subscription.credit_card_expiration_year,
        :ccZip        => customer.subscription.billing_zip_code,
      }
    }
  end

  describe "when having multiple subscriptions" do
    it "returns the latest one" do
      Mousetrap::Customer.new_from_api(full_customer).subscription.should_not be_nil
    end
  end

  describe '.all' do
    before do
      Mousetrap::Customer.stub :build_resources_from
    end

    it "gets all customers" do
      Mousetrap::Customer.should_receive(:get_resources).with('customers').and_return('some hash')
      Mousetrap::Customer.all
    end

    it "handles kludgy 'no customers found' response" do
      Mousetrap::Customer.stub :get_resources => {
        'error' => 'Resource not found: No customers found.'
      }
      Mousetrap::Customer.all.should == []
    end

    it "raises error if response has one" do
      expect do
        Mousetrap::Customer.stub :get_resources => { 'error' => "some other error" }
        Mousetrap::Customer.all
      end.to raise_error(RuntimeError, "some other error")
    end

    it "builds resources from the response" do
      Mousetrap::Customer.stub :get_resources => 'some hash'
      Mousetrap::Customer.should_receive(:build_resources_from).with('some hash')
      Mousetrap::Customer.all
    end
  end

  describe '.create' do
    before do
      @customer_hash = Factory.attributes_for :new_customer
      @customer = Mousetrap::Customer.new @customer_hash
      @customer.stub :create
      Mousetrap::Customer.stub(:new => @customer)
      Mousetrap::Customer.stub(:build_resource_from => stub(:id => 0))
    end

    it 'instantiates a customer with a hash of attributes' do
      Mousetrap::Customer.should_receive(:new).with(@customer_hash).and_return(@customer)
      Mousetrap::Customer.create(@customer_hash)
    end

    it 'creates the new customer instance' do
      @customer.should_receive :create
      Mousetrap::Customer.create(@customer_hash)
    end

    it 'returns an instance of Mousetrap::Customer' do
      Mousetrap::Customer.create(@customer_hash).should be_instance_of(Mousetrap::Customer)
    end
  end

  describe ".new" do
    subject do
      Mousetrap::Customer.new \
        :first_name => 'Jon',
        :last_name => 'Larkowski',
        :email => 'lark@example.com',
        :code => 'asfkhw0'
    end

    it { should be_instance_of(Mousetrap::Customer) }
    it { should be_new_record }

    describe "sets" do
      it 'first_name' do
        subject.first_name.should == 'Jon'
      end

      it 'last_name' do
        subject.last_name.should == 'Larkowski'
      end

      it 'email' do
        subject.email.should == 'lark@example.com'
      end

      it 'code' do
        subject.code.should == 'asfkhw0'
      end
    end
  end

  describe '.update' do
    def do_update
      Mousetrap::Customer.update('some customer code', 'some attributes')
    end

    it "makes a new customer from the attributes" do
      Mousetrap::Customer.should_receive(:new).with('some attributes').and_return(stub(:null_object => true))
      do_update
    end

    it "sets the new customer code to the argument" do
      customer = mock
      customer.stub :update
      Mousetrap::Customer.stub :new => customer
      customer.should_receive(:code=).with('some customer code')
      do_update
    end

    it "calls #update" do
      customer = mock(:null_object => true)
      Mousetrap::Customer.stub :new => customer
      customer.should_receive :update
      do_update
    end
  end

  describe '#cancel' do
    context "for existing records" do
      it 'cancels' do
        customer = Factory :existing_customer
        customer.should_receive(:member_action).with('cancel')
        customer.cancel
      end
    end

    context "for new records" do
      it "does nothing" do
        customer = Factory.build :new_customer
        customer.should_not_receive(:member_action).with('cancel')
        customer.cancel
      end
    end
  end

  describe "#new?" do
    it "looks up the customer on CheddarGetter" do
      c = Mousetrap::Customer.new :code => 'some_customer_code'
      Mousetrap::Customer.should_receive(:[]).with('some_customer_code')
      c.new?
    end

    context "with an existing CheddarGetter record" do
      before do
        Mousetrap::Customer.stub(:[] => stub(:id => 'some_customer_id'))
      end

      it "grabs the id from CheddarGetter and assigns it locally" do
        c = Mousetrap::Customer.new :code => 'some_customer_code'
        c.should_receive(:id=).with('some_customer_id')
        c.new?
      end

      it "is false" do
        c = Mousetrap::Customer.new
        c.should_not be_new
      end
    end

    context "without a CheddarGetter record" do
      before do
        Mousetrap::Customer.stub :[] => nil
      end

      it "is true" do
        c = Mousetrap::Customer.new
        c.should be_new
      end
    end
  end

  describe '#save' do
    context "for existing records" do
      before do
        @customer = Factory :existing_customer
        @customer.stub :new? => false
      end

      context "with subscription association set up" do
        it 'posts to edit action' do
          attributes_for_api = customer_attributes_for_api(@customer)

          # We don't send code for existing API resources.
          attributes_for_api.delete(:code)

          @customer.class.should_receive(:put_resource).with('customers', 'edit', @customer.code, attributes_for_api).and_return({:id => 'some_id'})
          @customer.save
        end
      end

      context "with no subscription association" do
        it 'posts to edit action' do
          attributes_for_api = customer_attributes_for_api(@customer)

          # We don't send code for existing API resources.
          attributes_for_api.delete(:code)

          attributes_for_api.delete(:subscription)
          @customer.subscription = nil

          @customer.class.should_receive(:put_resource).with('customers', 'edit-customer', @customer.code, attributes_for_api).and_return({:id => 'some_id'})
          @customer.save
        end
      end
    end

    context "for new records" do
      it 'calls create' do
        customer = Factory :new_customer
        customer.stub :new? => true
        Mousetrap::Customer.stub :exists? => false
        customer.should_receive(:create)
        customer.save
      end
    end
  end

  describe "#switch_to_plan" do
    it "raises an error if not existing CheddarGetter customer" do
      c = Mousetrap::Customer.new :code => 'some_customer_code'
      c.stub :exists? => false
      expect { c.switch_to_plan 'some_plan_code' }.to raise_error(/existing/)
    end

    it "puts a subscription with a plan code" do
      c = Mousetrap::Customer.new :code => 'some_customer_code'
      c.stub :exists? => true
      c.class.should_receive(:put_resource).with(
        'customers', 'edit-subscription', 'some_customer_code', { :planCode => 'some_plan_code' })
      c.switch_to_plan 'some_plan_code'
    end
  end

  describe "protected methods" do
    describe "#create" do
      before do
        @customer = Mousetrap::Customer.new
        @customer.stub :attributes_for_api_with_subscription => 'some_attributes'
      end

      it "posts a new customer" do
        @customer.class.should_receive(:post_resource).with('customers', 'new', 'some_attributes').and_return({:id => 'some_id'})
        @customer.class.stub :build_resource_from
        @customer.send :create
      end

      it "raises error if CheddarGetter reports one" do
        @customer.class.stub :post_resource => {'error' => 'some error message'}
        expect { @customer.send(:create) }.to raise_error('some error message')
      end

      it "builds a customer from the CheddarGetter return values" do
        @customer.class.stub :post_resource => 'some response'
        @customer.class.should_receive(:build_resource_from).with('some response').and_return(:id => 'some_id')
        @customer.send :create
      end

      it "grabs the id from CheddarGetter and assigns it locally" do
        @customer.class.stub :post_resource => {}
        @customer.class.stub :build_resource_from => stub(:id => 'some_id')
        @customer.should_receive(:id=).with('some_id')
        @customer.send :create
      end

      it "returns the response" do
        @customer.class.stub :post_resource => { :some => :response }
        @customer.class.stub :build_resource_from => stub(:id => 'some_id')
        @customer.send(:create).should == { :some => :response }
      end
    end

    describe "#update" do
      context "when there's a subscription instance" do
        let(:customer) { Mousetrap::Customer.new :code => 'some code' }

        it "puts the customer with subscription when there's a subscription instance" do
          customer.stub :subscription => stub
          customer.stub :attributes_for_api_with_subscription => 'some attributes with subscription'
          customer.class.should_receive(:put_resource).with('customers', 'edit', 'some code', 'some attributes with subscription').and_return({:id => 'some_id'})
          customer.send :update
        end

        it "puts just the customer when no subscription instance" do
          customer.stub :subscription => nil
          customer.stub :attributes_for_api => 'some attributes'
          customer.class.should_receive(:put_resource).with('customers', 'edit-customer', 'some code', 'some attributes').and_return({:id => 'some_id'})
          customer.send :update
        end

        it "raises error if CheddarGetter reports one" do
          customer.class.stub :put_resource => {'error' => 'some error message'}
          expect { customer.send(:update) }.to raise_error('some error message')
        end
      end
    end
  end
end


__END__

customers: 
  customer: 
    company: 
    lastName: cgejerpkyw
    code: krylmrreef@example.com
    subscriptions: 
      subscription: 
        plans: 
          plan: 
            name: Test
            setupChargeAmount: "42.00"
            code: TEST
            recurringChargeAmount: "13.00"
            billingFrequencyQuantity: "1"
            trialDays: "0"
            id: 8e933180-08b5-102d-a92d-40402145ee8b
            billingFrequency: monthly
            createdDatetime: "2009-10-12T19:28:09+00:00"
            recurringChargeCode: TEST_RECURRING
            isActive: "1"
            billingFrequencyUnit: months
            description: This is my test plan. There are many like it, but this one is mine.
            billingFrequencyPer: month
            setupChargeCode: TEST_SETUP
        gatewayToken: 
        id: 7ccea6de-0a4d-102d-a92d-40402145ee8b
        createdDatetime: "2009-10-14T20:08:14+00:00"
        ccType: visa
        ccLastFour: "1111"
        ccExpirationDate: "2012-12-31T00:00:00+00:00"
        canceledDatetime: 
        invoices: 
          invoice: 
          - number: "5"
            transactions: 
              transaction: 
                response: approved
                code: ""
                amount: "42.00"
                memo: This is a simulated transaction
                id: 7ce53c78-0a4d-102d-a92d-40402145ee8b
                createdDatetime: "2009-10-14T20:08:14+00:00"
                transactedDatetime: "2009-10-14T20:08:14+00:00"
                parentId: 
                charges: 
                  charge: 
                    code: TEST_SETUP
                    quantity: "1"
                    id: 7ce2cb6e-0a4d-102d-a92d-40402145ee8b
                    createdDatetime: "2009-10-14T20:08:14+00:00"
                    type: setup
                    eachAmount: "42.00"
                    description: 
                gatewayAccount: 
                  id: ""
            billingDatetime: "2009-10-14T20:08:14+00:00"
            id: 7cd25072-0a4d-102d-a92d-40402145ee8b
            createdDatetime: "2009-10-14T20:08:14+00:00"
            type: setup
          - number: "6"
            billingDatetime: "2009-11-14T20:08:14+00:00"
            id: 7cd4253c-0a4d-102d-a92d-40402145ee8b
            createdDatetime: "2009-10-14T20:08:14+00:00"
            type: subscription
    gatewayToken: 
    id: 7ccd6e5e-0a4d-102d-a92d-40402145ee8b
    createdDatetime: "2009-10-14T20:08:14+00:00"
    modifiedDatetime: "2009-10-14T20:08:14+00:00"
    firstName: wqaqyhjdfg
    email: krylmrreef@example.com
