require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Mousetrap do
  subject { Mousetrap }

  it "stores product code" do
    subject.product_code = 'my_product_code'
    subject.product_code.should == 'my_product_code'
  end
  
  describe "#authenticate" do
    it "sets basic auth based on the supplied user and password" do
      Mousetrap::Resource.should_receive(:basic_auth).with('lark@example.com', 'abc123')
      subject.authenticate 'lark@example.com', 'abc123'
    end
  end
end
