require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
end
