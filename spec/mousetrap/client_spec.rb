require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Client do
  before do
    Mousetrap.stub :get
    Mousetrap.stub :post
    @client = Mousetrap::Client.new 'lark@example.com', 'abc123', 'my_product_code'
  end

  describe "class" do
    it "sets the base URI" do
      Mousetrap::Client.default_options[:base_uri].should == 'https://cheddargetter.com'
    end

    it "set the header to our client name" do
      Mousetrap::Client.headers['User-Agent'].should == 'Mousetrap Ruby Client'
    end
  end

  describe "#initialize" do
    subject { Mousetrap::Client }

    it "requires a username, password, and product code" do
      expect { subject.new }.to raise_error
    end

    it "sets basic auth based on the supplied username and password" do
      subject.should_receive(:basic_auth).with('lark@example.com', 'abc123')
      subject.new 'lark@example.com', 'abc123', nil
    end
  end

  describe "#customers" do
    it "gets customers" do
      @client.should_receive(:get).with('customers')
      @client.customers
    end
  end

  describe "#create_customer" do
    it "creates a customer" do
      @client.should_receive(:post).with('customers', 'new', 'some_hash')
      @client.create_customer('some_hash')
    end
  end

  describe "#get" do
    it "gets /xml/<resource>/get/productCode/<my_product_code>" do
      @client.class.should_receive(:get).with('/xml/some_resource/get/productCode/my_product_code')
      @client.send(:get, 'some_resource')
    end
  end

  describe "#post" do
    it "posts to /xml/<resource>/<action>/productCode/<product_code>" do
      @client.class.should_receive(:post).with('/xml/some_resource/some_action/productCode/my_product_code', :body => 'some_hash')
      @client.send(:post, 'some_resource', 'some_action', 'some_hash')
    end
  end
end
