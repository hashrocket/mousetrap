Factory.define :new_customer, :class => Mousetrap::Customer, :default_strategy => :stub do |f|
  f.email { random_email_address }
  f.first_name 'Jon'
  f.last_name 'Larkowski'
  f.code { |me| me.email }
  f.add_attribute :id, nil
  f.subscription_attributes { Factory.attributes_for :subscription }
end

Factory.define :existing_customer, :parent => :new_customer, :default_strategy => :stub do |f|
  f.add_attribute :id, '2d1244e8-e338-102c-a92d-40402145ee8b'
end

Factory.define :subscription, :class => Mousetrap::Subscription, :default_strategy => :stub do |f|
  f.plan_code 'TEST'
  f.billing_first_name { random_string }
  f.billing_last_name { random_string }
  f.credit_card_number '4111111111111111'
  f.credit_card_expiration '12-2012'
  f.billing_zip_code '90210'
end
