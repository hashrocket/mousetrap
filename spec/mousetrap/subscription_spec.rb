require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

FULL_CUSTOMER ={"company"=>nil, "lastName"=>"LasterName1255024322", "code"=>"1255024322", "gatewayToken"=>nil, "createdDatetime"=>"2009-10-08T17:55:30+00:00", "modifiedDatetime"=>"2009-10-08T17:55:30+00:00", "subscriptions"=>{"subscription"=>[{"ccExpirationDate"=>"2010-01-31T00:00:00+00:00", "plans"=>{"plan"=>{"name"=>"Plus", "billingFrequencyQuantity"=>"1", "code"=>"PLUS", "recurringChargeAmount"=>"49.00", "createdDatetime"=>"2009-10-06T14:54:24+00:00", "id"=>"51a912d0-03d8-102d-a92d-40402145ee8b", "isActive"=>"1", "billingFrequency"=>"monthly", "description"=>nil, "trialDays"=>"0", "setupChargeCode"=>"PLUS_SETUP", "recurringChargeCode"=>"PLUS_RECURRING", "billingFrequencyUnit"=>"months", "setupChargeAmount"=>"49.00", "billingFrequencyPer"=>"month"}}, "gatewayToken"=>nil, "createdDatetime"=>"2009-10-08T17:55:31+00:00", "ccType"=>"visa", "id"=>"f426d5ae-0583-102d-a92d-40402145ee8b", "ccLastFour"=>"2222", "canceledDatetime"=>nil, "invoices"=>{"invoice"=>{"number"=>"12", "createdDatetime"=>"2009-10-08T17:55:30+00:00", "type"=>"subscription", "billingDatetime"=>"2009-11-08T17:55:30+00:00", "id"=>"f3142928-0583-102d-a92d-40402145ee8b"}}}, {"ccExpirationDate"=>"2010-01-31T00:00:00+00:00", "plans"=>{"plan"=>{"name"=>"Basic", "billingFrequencyQuantity"=>"1", "code"=>"BASIC", "recurringChargeAmount"=>"24.00", "createdDatetime"=>"2009-10-06T14:53:49+00:00", "id"=>"3cd2e840-03d8-102d-a92d-40402145ee8b", "isActive"=>"1", "billingFrequency"=>"monthly", "description"=>nil, "trialDays"=>"0", "setupChargeCode"=>"BASIC_SETUP", "recurringChargeCode"=>"BASIC_RECURRING", "billingFrequencyUnit"=>"months", "setupChargeAmount"=>"24.00", "billingFrequencyPer"=>"month"}}, "gatewayToken"=>nil, "createdDatetime"=>"2009-10-08T17:55:30+00:00", "ccType"=>"visa", "id"=>"f30e0e94-0583-102d-a92d-40402145ee8b", "ccLastFour"=>"2222", "canceledDatetime"=>nil, "invoices"=>{"invoice"=>{"number"=>"11", "createdDatetime"=>"2009-10-08T17:55:30+00:00", "transactions"=>{"transaction"=>{"response"=>"approved", "code"=>"", "createdDatetime"=>"2009-10-08T17:55:30+00:00", "memo"=>"This is a simulated transaction", "id"=>"f327b178-0583-102d-a92d-40402145ee8b", "parentId"=>nil, "amount"=>"24.00", "transactedDatetime"=>"2009-10-08T17:55:30+00:00", "gatewayAccount"=>{"id"=>""}, "charges"=>{"charge"=>{"code"=>"BASIC_SETUP", "createdDatetime"=>"2009-10-08T17:55:30+00:00", "type"=>"setup", "quantity"=>"1", "id"=>"f325406e-0583-102d-a92d-40402145ee8b", "description"=>nil, "eachAmount"=>"24.00"}}}}, "type"=>"setup", "billingDatetime"=>"2009-10-08T17:55:30+00:00", "id"=>"f3125468-0583-102d-a92d-40402145ee8b"}}}]}, "id"=>"f30cd614-0583-102d-a92d-40402145ee8b", "firstName"=>"FirsterName1", "email"=>"example1@example.com"}
MULTIPLE_SUBSCRIPTIONS =[{"ccExpirationDate"=>"2010-01-31T00:00:00+00:00", "plans"=>{"plan"=>{"name"=>"Plus", "billingFrequencyQuantity"=>"1", "code"=>"PLUS", "recurringChargeAmount"=>"49.00", "createdDatetime"=>"2009-10-06T14:54:24+00:00", "id"=>"51a912d0-03d8-102d-a92d-40402145ee8b", "isActive"=>"1", "billingFrequency"=>"monthly", "description"=>nil, "trialDays"=>"0", "setupChargeCode"=>"PLUS_SETUP", "recurringChargeCode"=>"PLUS_RECURRING", "billingFrequencyUnit"=>"months", "setupChargeAmount"=>"49.00", "billingFrequencyPer"=>"month"}}, "gatewayToken"=>nil, "createdDatetime"=>"2009-10-08T17:55:31+00:00", "ccType"=>"visa", "id"=>"f426d5ae-0583-102d-a92d-40402145ee8b", "ccLastFour"=>"2222", "canceledDatetime"=>nil, "invoices"=>{"invoice"=>{"number"=>"12", "createdDatetime"=>"2009-10-08T17:55:30+00:00", "type"=>"subscription", "billingDatetime"=>"2009-11-08T17:55:30+00:00", "id"=>"f3142928-0583-102d-a92d-40402145ee8b"}}}, {"ccExpirationDate"=>"2010-01-31T00:00:00+00:00", "plans"=>{"plan"=>{"name"=>"Basic", "billingFrequencyQuantity"=>"1", "code"=>"BASIC", "recurringChargeAmount"=>"24.00", "createdDatetime"=>"2009-10-06T14:53:49+00:00", "id"=>"3cd2e840-03d8-102d-a92d-40402145ee8b", "isActive"=>"1", "billingFrequency"=>"monthly", "description"=>nil, "trialDays"=>"0", "setupChargeCode"=>"BASIC_SETUP", "recurringChargeCode"=>"BASIC_RECURRING", "billingFrequencyUnit"=>"months", "setupChargeAmount"=>"24.00", "billingFrequencyPer"=>"month"}}, "gatewayToken"=>nil, "createdDatetime"=>"2009-10-08T17:55:30+00:00", "ccType"=>"visa", "id"=>"f30e0e94-0583-102d-a92d-40402145ee8b", "ccLastFour"=>"2222", "canceledDatetime"=>nil, "invoices"=>{"invoice"=>{"number"=>"11", "createdDatetime"=>"2009-10-08T17:55:30+00:00", "transactions"=>{"transaction"=>{"response"=>"approved", "code"=>"", "createdDatetime"=>"2009-10-08T17:55:30+00:00", "memo"=>"This is a simulated transaction", "id"=>"f327b178-0583-102d-a92d-40402145ee8b", "parentId"=>nil, "amount"=>"24.00", "transactedDatetime"=>"2009-10-08T17:55:30+00:00", "gatewayAccount"=>{"id"=>""}, "charges"=>{"charge"=>{"code"=>"BASIC_SETUP", "createdDatetime"=>"2009-10-08T17:55:30+00:00", "type"=>"setup", "quantity"=>"1", "id"=>"f325406e-0583-102d-a92d-40402145ee8b", "description"=>nil, "eachAmount"=>"24.00"}}}}, "type"=>"setup", "billingDatetime"=>"2009-10-08T17:55:30+00:00", "id"=>"f3125468-0583-102d-a92d-40402145ee8b"}}}]


describe Mousetrap::Subscription do
  # subscription:
  #   ccExpirationDate: "2010-01-31T00:00:00+00:00"
  #   gatewayToken:
  #   createdDatetime: "2009-08-27T15:55:51+00:00"
  #   ccType: visa
  #   id: 46ad3f1c-e472-102c-a92d-40402145ee8b
  #   ccLastFour: "1111"
  #   canceledDatetime:

  describe '.[]' do
    it 'raises NotImplementedError' do
      expect do
        Mousetrap::Subscription['some_code']
      end.to raise_error(NotImplementedError, Mousetrap::API_UNSUPPORTED)
    end
  end

  describe '.all' do
    it 'raises NotImplementedError' do
      expect do
        Mousetrap::Subscription.all
      end.to raise_error(NotImplementedError, Mousetrap::API_UNSUPPORTED)
    end
  end

  describe '.destroy_all' do
    it 'raises NotImplementedError' do
      expect do
        Mousetrap::Subscription.destroy_all
      end.to raise_error(NotImplementedError, Mousetrap::API_UNSUPPORTED)
    end
  end

  describe '.exists?' do
    it 'raises NotImplementedError' do
      expect do
        Mousetrap::Subscription.exists?('some_code')
      end.to raise_error(NotImplementedError, Mousetrap::API_UNSUPPORTED)
    end
  end

  describe "plan" do
    it 'has the correct planCode populated' do
      Mousetrap::Subscription.new_from_api(MULTIPLE_SUBSCRIPTIONS.first).plan.code.should == "PLUS"
    end

    it 'exists' do
      Mousetrap::Subscription.new_from_api(MULTIPLE_SUBSCRIPTIONS.first).plan.should_not be_nil
    end
  end
  describe '#destroy' do
    it "raises a NotImplementedError" do
      expect do
        Mousetrap::Subscription.new.destroy
      end.to raise_error(NotImplementedError)
    end
  end

  describe '::attributes_for_api' do
    it 'coerces the month to 2 digits' do
      Mousetrap::Subscription.attributes_for_api(
        :credit_card_expiration_month => 2
      )[:ccExpMonth].should == '02'
    end
  end

  describe '#exists?' do
    it 'raises NotImplementedError' do
      expect do
        s = Mousetrap::Subscription.new
        s.exists?
      end.to raise_error(NotImplementedError, Mousetrap::API_UNSUPPORTED)
    end
  end
end
