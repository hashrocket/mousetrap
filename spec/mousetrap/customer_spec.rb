require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Customer do
  def customer_attributes_for_api(customer)
    {
      :firstName => customer.first_name,
      :lastName => customer.last_name,
      :email => customer.email,
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

  describe '.create' do
    before do
      @customer_hash = Factory.attributes_for :new_customer
      @customer = Mousetrap::Customer.new @customer_hash
      @customer.stub(:save)
      Mousetrap::Customer.stub(:new => @customer)
      Mousetrap::Customer.stub(:build_resource_from => stub(:id => 0))
    end

    it 'instantiates a customer with a hash of attributes' do
      Mousetrap::Customer.should_receive(:new).with(@customer_hash).and_return(@customer)
      Mousetrap::Customer.create(@customer_hash)
    end

    it 'saves the new customer instance' do
      @customer.should_receive(:save)
      Mousetrap::Customer.create(@customer_hash)
    end

    it 'sets the id of the newly created customer' do
      Mousetrap::Customer.stub(:build_resource_from => stub(:id => 1))
      @customer.should_receive(:id=).with(1)
      Mousetrap::Customer.create(@customer_hash)
    end

    it 'returns an instance of Mousetrap::Customer' do
      Mousetrap::Customer.create(@customer_hash).should be_instance_of(Mousetrap::Customer)
    end
  end

  describe ".destroy_all" do
    it "finds all" do
      Mousetrap::Customer.should_receive(:all).and_return([])
      Mousetrap::Customer.destroy_all
    end

    it "calls destroy on each customer" do
      c1, c2, c3 = mock, mock, mock
      Mousetrap::Customer.stub(:all => [c1, c2,c3])
      c1.should_receive :destroy
      c2.should_receive :destroy
      c3.should_receive :destroy
      Mousetrap::Customer.destroy_all
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

  describe '#destroy' do
    context "for existing records" do
      it 'destroys' do
        customer = Factory :existing_customer
        Mousetrap::Customer.should_receive(:delete_resource).with('customers', customer.code)
        customer.destroy
      end
    end

    context "for new records" do
      it "does nothing" do
        customer = Factory :new_customer
        Mousetrap::Customer.should_not_receive(:delete_resource)
        customer.destroy
      end
    end
  end

  describe '#save' do
    context "for existing records" do
      before do
        @customer = Factory :existing_customer
      end

      it 'posts to edit-customer action' do
        attributes_for_api = customer_attributes_for_api(@customer)

        # We don't send code for existing API resources.
        attributes_for_api.delete(:code)

        @customer.class.should_receive(:put_resource).with(
          'customers', 'edit-customer', @customer.code, attributes_for_api)
        @customer.save
      end
    end

    context "for new records" do
      it 'calls create' do
        customer = Factory :new_customer
        customer.should_receive(:create)
        customer.save
      end
    end
  end
end
