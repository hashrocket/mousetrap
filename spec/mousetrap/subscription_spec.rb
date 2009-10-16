require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Subscription do
  # subscription:
  #   ccExpirationDate: "2010-01-31T00:00:00+00:00"
  #   gatewayToken:
  #   createdDatetime: "2009-08-27T15:55:51+00:00"
  #   ccType: visa
  #   id: 46ad3f1c-e472-102c-a92d-40402145ee8b
  #   ccLastFour: "1111"
  #   canceledDatetime:

  include Fixtures

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
      Mousetrap::Subscription.new_from_api(multiple_subscriptions.first).plan.code.should == "PLUS"
    end

    it 'exists' do
      Mousetrap::Subscription.new_from_api(multiple_subscriptions.first).plan.should_not be_nil
    end
  end

  describe '#destroy' do
    it "raises a NotImplementedError" do
      expect do
        Mousetrap::Subscription.new.destroy
      end.to raise_error(NotImplementedError)
    end
  end

  describe '.attributes_for_api' do
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
