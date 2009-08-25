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
end
