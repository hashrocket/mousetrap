require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Plan do
  # name: Test
  # billingFrequencyQuantity: "1"
  # code: TEST
  # recurringChargeAmount: "42.00"
  # createdDatetime: "2009-08-25T04:24:34+00:00"
  # id: 5fbb9a84-e27f-102c-a92d-40402145ee8b
  # isActive: "1"
  # billingFrequency: monthly
  # description: Test
  # trialDays: "0"
  # setupChargeCode: TEST_SETUP
  # recurringChargeCode: TEST_RECURRING
  # billingFrequencyUnit: months
  # setupChargeAmount: "0.00"
  # billingFrequencyPer: month

  describe ".all" do
    before do
      Mousetrap::Plan.stub :build_resources_from
    end

    it "gets all plans" do
      Mousetrap::Plan.should_receive(:get_resources).with('plans').and_return('some hash')
      Mousetrap::Plan.all
    end

    it "handles no-plans case" do
      Mousetrap::Plan.stub :get_resources => { 'plans' => nil }
      Mousetrap::Plan.all.should == []
    end

    it "builds resources from the response" do
      Mousetrap::Plan.stub :get_resources => { 'plans' => 'some hash' }
      Mousetrap::Plan.should_receive(:build_resources_from).with({ 'plans' => 'some hash' })
      Mousetrap::Plan.all
    end
  end
end
