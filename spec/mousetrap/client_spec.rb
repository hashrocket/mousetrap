require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Client do
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
      subject.should_receive(:basic_auth).with('jon@example.com', 'abc123')
      subject.new 'jon@example.com', 'abc123', nil
    end
  end

  describe "#customers" do
    subject { Mousetrap::Client.allocate }

    it "gets customers" do
      subject.should_receive(:get).with('customers')
      subject.customers
    end
  end
end
