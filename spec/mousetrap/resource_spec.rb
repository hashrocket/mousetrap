require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Mousetrap
  class Widget < Resource
    attr_accessor :id
    attr_accessor :code


    protected

    def self.attributes_from_api(attributes)
      {
        :id   => attributes['id'],
        :code => attributes['code'],
      }
    end

    def self.plural_resource_name
      'widgets'
    end

    def self.singular_resource_name
      'widget'
    end
  end
end

describe Mousetrap::Resource do
  before do
    Mousetrap.product_code = 'my_product_code'
  end

  subject { Mousetrap::Resource }

  describe "class" do
    it "sets the base URI" do
      subject.default_options[:base_uri].should == 'https://cheddargetter.com'
    end

    it "set the header to our client name" do
      subject.headers['User-Agent'].should == 'Mousetrap Ruby Client'
    end
  end

  describe ".[]" do
    before do
      customer_hash = Factory.attributes_for :existing_customer
      customer_hash = HashWithIndifferentAccess.new customer_hash
      @code = customer_hash[:code]
      @server_response_hash = { 'widgets' => { 'widget' => customer_hash } }
      Mousetrap::Widget.stub(:get_resource => @server_response_hash)
    end

    it "gets a resource with widget code" do
      Mousetrap::Widget.should_receive(:get_resource).with('widgets', @code).and_return(@server_response_hash)
      Mousetrap::Widget[@code]
    end

    context "returned widget instance" do
      subject { Mousetrap::Widget[@code] }
      it { should be_instance_of(Mousetrap::Widget) }
      it { should_not be_new_record }
      it { subject.code.should == @code }
    end
  end

  describe '.all' do
    it 'gets widgets resources' do
      Mousetrap::Widget.stub(:build_resources_from)
      Mousetrap::Widget.should_receive(:get_resources).with('widgets')
      Mousetrap::Widget.all
    end

    it 'builds widget resources' do
      response = stub
      Mousetrap::Widget.stub(:get_resources => response)
      Mousetrap::Widget.should_receive(:build_resources_from).with(response)
      Mousetrap::Widget.all
    end
  end

  describe '#destroy' do
    context "for existing records" do
      it 'destroys' do
        widget = Mousetrap::Widget.new
        widget.stub :new_record? => false
        widget.should_receive(:member_action).with('delete')
        widget.destroy
      end
    end

    #context "for new records" do
      #it "does nothing" do
        #customer = Factory :new_customer
        #Mousetrap::Customer.should_not_receive(:delete_resource)
        #customer.destroy
      #end
    #end
  end


  describe ".delete_resource" do
    it "gets /xml/<resource>/delete/productCode/<my_product_code>/code/<resource_code>" do
      subject.should_receive(:post).with('/xml/widgets/delete/productCode/my_product_code/code/some_resource_code')
      subject.delete_resource 'widgets', 'some_resource_code'
    end
  end

  describe ".get_resource" do
    it "gets /xml/<resource>/get/productCode/<my_product_code>/code/<resource_code>" do
      subject.should_receive(:get).with('/xml/widgets/get/productCode/my_product_code/code/some_resource_code')
      subject.get_resource 'widgets', 'some_resource_code'
    end
  end

  describe ".get_resources" do
    it "gets /xml/<resource>/get/productCode/<my_product_code>" do
      subject.should_receive(:get).with('/xml/widgets/get/productCode/my_product_code')
      subject.get_resources 'widgets'
    end
  end

  describe ".post_resource" do
    it "posts to /xml/<resource>/<action>/productCode/<product_code>" do
      subject.should_receive(:post).with('/xml/widgets/some_action/productCode/my_product_code', :body => 'some_hash')
      subject.post_resource 'widgets', 'some_action', 'some_hash'
    end
  end

  describe ".put_resource" do
    it "puts to /xml/<resource>/<action>/productCode/<product_code>/code/<resource_code>" do
      subject.should_receive(:post).with(
        '/xml/widgets/some_action/productCode/my_product_code/code/some_widget_code',
        :body => 'some_hash')
      subject.put_resource 'widgets', 'some_action', 'some_widget_code', 'some_hash'
    end
  end
end
