Factory.define :new_customer, :class => Mousetrap::Customer, :default_strategy => :stub do |f|
  f.add_attribute :id, nil
  f.code { |me| me.email }
  f.email { random_email_address }
  f.first_name 'Jon'
  f.last_name 'Larkowski'
end

Factory.define :existing_customer, :parent => :new_customer, :default_strategy => :stub do |f|
  f.add_attribute :id, '2d1244e8-e338-102c-a92d-40402145ee8b'
end

