require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Customer do
  describe '.all' do
    it 'gets customers resources' do
      Mousetrap::Customer.stub(:build_resources_from)
      Mousetrap::Customer.should_receive(:get_resources).with('customers')
      Mousetrap::Customer.all
    end

    it 'builds customer resources' do
      response = stub
      Mousetrap::Customer.stub(:get_resources => response)
      Mousetrap::Customer.should_receive(:build_resources_from).with(response)
      Mousetrap::Customer.all
    end
  end

  describe '.create' do
    before do
      customer_hash = Factory.attributes_for :new_customer
      @customer_hash = customer_hash
      @response = {'customers' => {'customer' => {'id' => '2d1244e8-e338-102c-a92d-40402145ee8b'}}}
      Mousetrap::Customer.stub(:post_resource).and_return(@response)
    end

    subject { Mousetrap::Customer.create(@customer_hash) }

    it "posts customer attributes" do
      mutated_hash = {
        :firstName => @customer_hash[:first_name],
        :lastName => @customer_hash[:last_name],
        :email => @customer_hash[:email],
        :code => @customer_hash[:code],
      }
      Mousetrap::Customer.should_receive(:post_resource).with('customers', 'new', mutated_hash).and_return(@response)
      subject
    end

    it { should be_instance_of(Mousetrap::Customer) }
    it { should_not be_new_record }
  end

  describe ".[]" do
    before do
      customer_hash = Factory.attributes_for :existing_customer
      customer_hash = HashWithIndifferentAccess.new customer_hash
      @code = customer_hash[:code]
      @server_response_hash = { 'customers' => { 'customer' => customer_hash } }
      Mousetrap::Customer.stub(:get_resource => @server_response_hash)
    end

    it "gets a resource with customer code" do
      Mousetrap::Customer.should_receive(:get_resource).with('customers', @code).and_return(@server_response_hash)
      Mousetrap::Customer[@code]
    end

    context "returned customer instance" do
      subject { Mousetrap::Customer[@code] }
      it { should be_instance_of(Mousetrap::Customer) }
      it { should_not be_new_record }
      it { subject.code.should == @code }
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
        mutated_hash = {
          :firstName => @customer.first_name,
          :lastName => @customer.last_name,
          :email => @customer.email,
        }

        @customer.class.should_receive(:put_resource).with(
          'customers', 'edit-customer', @customer.code, mutated_hash)
        @customer.save!
      end
    end

    context "for new records" do
      before do
        @customer = Factory :new_customer
      end

      it 'calls create' do
        mutated_hash = {
          :firstName => @customer.first_name,
          :lastName => @customer.last_name,
          :email => @customer.email,
          :code => @customer.code
        }
        Mousetrap::Customer.should_receive(:create).with(mutated_hash)
        @customer.save!
      end
    end
  end
end
