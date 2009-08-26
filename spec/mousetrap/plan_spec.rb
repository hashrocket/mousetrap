require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# API responses
# --- 
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
# --- 
# name: Test 2
# billingFrequencyQuantity: "1"
# code: TEST_2
# recurringChargeAmount: "84.00"
# createdDatetime: "2009-08-25T20:07:04+00:00"
# id: 0a7c3a54-e303-102c-a92d-40402145ee8b
# isActive: "0"
# billingFrequency: monthly
# description: Another test.
# trialDays: "13"
# setupChargeCode: TEST_2_SETUP
# recurringChargeCode: TEST_2_RECURRING
# billingFrequencyUnit: months
# setupChargeAmount: "99.00"
# billingFrequencyPer: month


describe Mousetrap::Plan do
  subject { Mousetrap::Plan }

  describe ".[]" do
    it "gets a plan based on code" do
      subject.should_receive(:get_resource).with('plans', 'some_plan_code')
      subject['some_plan_code']
    end
  end
end
