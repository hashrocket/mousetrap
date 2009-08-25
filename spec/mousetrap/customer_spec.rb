require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Customer do
  subject { Mousetrap::Customer }

  describe '.all' do
    it 'gets customers resources' do
      subject.should_receive(:get_resources).with('customers')
      subject.all
    end
  end

  describe '.create' do
    before do
      @customer_hash = {:first_name => 'joe', :last_name => 'smith', :code => '234sesa32', :email => 'joesmith@example.com'}
      response = {'customers' => {'customer' => {'id' => '2d1244e8-e338-102c-a92d-40402145ee8b'}}}
      subject.should_receive(:post_resource).with('customers', 'new', @customer_hash).and_return(response)
    end

    it "returns a Customer instance" do
      subject.create(@customer_hash).should be_instance_of(Mousetrap::Customer)
    end

    it "is not a new_record?" do
      subject.create(@customer_hash).should_not be_new_record
    end
  end

  describe ".[]" do
    before do
      customer_hash = {
        'id' => '2d1244e8-e338-102c-a92d-40402145ee8b',
        'code' => 'asfkhw0',
        'email' => 'lark@example.com',
        'first_name' => 'Jon',
        'last_name' => 'Larkowski'
      }
      server_response_hash = { 'customers' => { 'customer' => customer_hash } }
      subject.should_receive(:get_resource).with('customers', 'some_customer_code').and_return(server_response_hash)
    end
    
    it "gets a resource with customer code" do
      subject['some_customer_code']
    end
    
    it "returns a Customer instance" do
      subject['some_customer_code'].should be_instance_of(Mousetrap::Customer)
    end

    it "is not a new_record?" do
      subject['some_customer_code'].should_not be_new_record
    end

    it "has a code assigned" do
      subject['some_customer_code'].code.should == 'asfkhw0'
    end
  end
  
  describe ".new" do
    it "instantiates an object" do
      customer = Mousetrap::Customer.new({})
      customer.should be_instance_of(subject)
    end
    
    it "requires a hash" do
      expect { Mousetrap::Customer.new }.to raise_error(StandardError)
    end
    
    it 'is a new_record?' do
      Mousetrap::Customer.new({}).should be_new_record
    end

    describe "sets" do
      before do
        @customer = Mousetrap::Customer.new \
          :first_name => 'Jon',
          :last_name => 'Larkowski',
          :email => 'lark@example.com',
          :code => 'asfkhw0'
      end
      
      it 'first_name' do
        @customer.first_name.should == 'Jon'
      end
      
      it 'last_name' do
        @customer.last_name.should == 'Larkowski'
      end
      
      it 'email' do
        @customer.email.should == 'lark@example.com'
      end
      
      it 'code' do
        @customer.code.should == 'asfkhw0'
      end
    end

  end
  
  describe "accessors" do
    subject { Mousetrap::Customer.allocate }
    
    it "first_name" do
      subject.should respond_to(:first_name)
    end

    it "first_name=" do
      subject.should respond_to(:first_name=)
    end

    it "last_name" do
      subject.should respond_to(:last_name)
    end

    it "last_name=" do
      subject.should respond_to(:last_name=)
    end

    it "email" do
      subject.should respond_to(:email)
    end

    it "email=" do
      subject.should respond_to(:email=)
    end

    it "code" do
      subject.should respond_to(:code)
    end

    it "code=" do
      subject.should respond_to(:code=)
    end
  end

  describe '#save' do
    before do
      @customer_hash = {
        :first_name => 'Jon',
        :last_name => 'Larkowski',
        :email => 'lark@example.com'        
      }
      
      @code = "asdlkj342o"
      attributes = @customer_hash.merge :code => @code
      @customer = Mousetrap::Customer.new(attributes)
    end
  
    it 'posts to edit-customer action' do
      mutated_hash = {
        :firstName => 'Jon',
        :lastName => 'Larkowski',
        :email => 'lark@example.com'        
      }
      
      @customer.class.should_receive(:put_resource).with('customers',
                                                         'edit-customer', @code, mutated_hash)
      @customer.save!
    end
  end
end
