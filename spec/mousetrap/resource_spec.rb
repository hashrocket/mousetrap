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

    context "when there's errors" do
      it "handles kludgy 'Resource not found' response" do
        Mousetrap::Widget.stub :get_resource => {
          'error' => 'Resource not found: Customer not found for code=cantfindme within productCode=MOUSETRAP_TEST'
        }
        Mousetrap::Widget['cantfindme'].should be_nil
      end

      it "raises error if response has one" do
        expect do
          Mousetrap::Widget.stub :get_resource => { 'error' => 'some other error' }
          Mousetrap::Widget['some_resource_code'].should be_nil
        end.to raise_error(RuntimeError, 'some other error')
      end
    end
  end

  describe ".destroy_all" do
    it "destroys each resource" do
      all_widgets = [stub, stub, stub]
      Mousetrap::Widget.stub :all => all_widgets
      all_widgets.each { |w| w.should_receive :destroy }
      Mousetrap::Widget.destroy_all
    end
  end

  describe ".exists?" do
    it "gets by code" do
      Mousetrap::Widget.should_receive(:[]).with('some_resource_code')
      Mousetrap::Widget.exists? 'some_resource_code'
    end

    it "returns true when resource exists" do
      Mousetrap::Widget.stub :[] => stub('some_widget')
      Mousetrap::Widget.exists?('some_resource_code').should be_true
    end

    it "returns false when resource doesn't exist" do
      Mousetrap::Widget.stub :[] => nil
      Mousetrap::Widget.exists?('some_resource_code').should be_false
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

    context "for new records" do
      it "does nothing" do
        widget = Mousetrap::Widget.new
        widget.stub :new_record? => true
        Mousetrap::Customer.should_not_receive(:member_action)
        widget.destroy
      end
    end
  end

  describe "#exists?" do
    it "calls .exists? with code" do
      Mousetrap::Widget.should_receive(:exists?).with('some_resource_code')
      r = Mousetrap::Widget.new :code => 'some_resource_code'
      r.exists?
    end
  end

  describe '#new?' do
    it 'is true if id is nil' do
      s = Mousetrap::Widget.new
      s.should be_new
    end

    it 'is false if id exists' do
      s = Mousetrap::Widget.new
      s.stub :id => 'some_id'
      s.should_not be_new
    end
  end

  describe "protected methods" do
    describe ".delete_resource" do
      it "gets /xml/<resource>/delete/productCode/<my_product_code>/code/<resource_code>" do
        subject.should_receive(:post).with('/xml/widgets/delete/productCode/my_product_code/code/some_resource_code')
        subject.delete_resource 'widgets', 'some_resource_code'
      end
    end

    describe ".get_resource" do
      it "gets /xml/<resource>/get/productCode/<my_product_code>/code/<resource_code>" do
        subject.should_receive(:get).with('/xml/widgets/get/productCode/my_product_code/code/some%2Bresource%2Bcode')
        subject.get_resource 'widgets', 'some+resource+code'
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
end
