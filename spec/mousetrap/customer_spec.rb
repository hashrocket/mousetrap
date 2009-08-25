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
    it "creates a customer" do
      subject.should_receive(:post_resource).with('customers', 'new', 'some_hash')
      subject.create('some_hash')
    end
  end
  
  describe ".[]" do
    it "gets a customer based on code" do
      subject.should_receive(:get_resource).with('customers', 'some_customer_code')
      subject['some_customer_code']
    end
  end
  
  describe ".new" do
    it "instantiates an object" do
      customer = Mousetrap::Customer.new({})
      customer.should be_instance_of(subject)
    end
    
    it "takes a hash" do
      expect { Mousetrap::Customer.new }.to raise_error(StandardError)
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
