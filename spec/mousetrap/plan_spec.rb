require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Plan do
  subject { Mousetrap::Plan }

  describe '.all' do
    it 'gets plan resources' do
      subject.should_receive(:get_resources).with('plans')
      subject.all
    end
  end

  describe ".[]" do
    it "gets a plan based on code" do
      subject.should_receive(:get_resource).with('plans', 'some_plan_code')
      subject['some_plan_code']
    end
  end
end
