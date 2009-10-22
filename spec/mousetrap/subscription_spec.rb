require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mousetrap::Subscription do
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
    context "when month is set" do
      it 'coerces the month to 2 digits' do
        Mousetrap::Subscription.attributes_for_api(
          :credit_card_expiration_month => 2
        )[:ccExpMonth].should == '02'
      end
    end

    context "when month is not set" do
      it "is nil" do
        Mousetrap::Subscription.attributes_for_api(
          :credit_card_expiration_month => nil
        )[:ccExpMonth].should == nil
      end
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

  describe '.update' do
    before do
      Mousetrap::Subscription.stub :put_resource => { 'some' => 'hash' }
    end

    let (:mutated_attributes) do
      {
        :with => 'something',
        :without => nil,
        :also_without => ''
      }
    end

    def do_update
      Mousetrap::Subscription.update('some customer code', 'some attributes')
    end

    it "transforms the attribute names for CheddarGetter" do
      Mousetrap::Subscription.should_receive(:attributes_for_api).with('some attributes').and_return({})
      do_update
    end

    it "deletes unfilled attribute entries" do

      Mousetrap::Subscription.stub :attributes_for_api => mutated_attributes

      Mousetrap::Subscription.should_receive(:put_resource).with(
        'customers',
        'edit-subscription',
        'some customer code',
        { :with => 'something' }
      )

      do_update
    end

    it "calls put_resource" do
      Mousetrap::Subscription.stub :attributes_for_api => mutated_attributes

      Mousetrap::Subscription.should_receive(:put_resource).with(
        'customers',
        'edit-subscription',
        'some customer code',
        { :with => 'something' }
      )

      do_update
    end

    it "raises a CheddarGetter error if returned" do
      Mousetrap::Subscription.stub \
        :attributes_for_api => mutated_attributes,
        :put_resource => { 'error' => 'some error message' }

      expect { do_update }.to raise_error('some error message')
    end
  end
end


__END__

subscription:
  ccExpirationDate: "2010-01-31T00:00:00+00:00"
  gatewayToken:
  createdDatetime: "2009-08-27T15:55:51+00:00"
  ccType: visa
  id: 46ad3f1c-e472-102c-a92d-40402145ee8b
  ccLastFour: "1111"
  canceledDatetime:
