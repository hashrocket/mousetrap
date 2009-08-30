module Mousetrap
  class Subscription < Resource
    # Attributes we send _to_ the API.
    attr_accessor :plan_code
    attr_accessor :billing_first_name
    attr_accessor :billing_last_name
    attr_accessor :credit_card_number
    attr_accessor :credit_card_expiration
    attr_accessor :billing_zip_code

    # A Subscription belongs to a Customer.
    attr_accessor :customer_code

    # Attributes that come from the API, a subset of what we sent to the API.
    attr_accessor :id
    attr_accessor :canceled_at
    attr_accessor :created_at
    attr_accessor :credit_card_expiration_date
    attr_accessor :credit_card_last_four_digits
    attr_accessor :credit_card_type

    # TODO:  not sure if .all or .[] will work

    def attributes
      {
        :id => id,
        :plan_code => plan_code,
        :billing_first_name => billing_first_name,
        :billing_last_name => billing_last_name,
        :credit_card_number => credit_card_number,
        :credit_card_expiration => credit_card_expiration,
        :billing_zip_code => billing_zip_code,
      }
    end

    def attributes_for_api
      self.class.attributes_for_api(attributes)
    end

    def save
      mutated_attributes = attributes_for_api(attributes)
      self.class.put_resource('customers', 'edit-subscription', customer_code, mutated_attributes)
    end


    protected

    def self.plural_resource_name
      'subscriptions'
    end

    def self.singular_resource_name
      'subscription'
    end

    def self.attributes_for_api(resource_attributes)
      {
        :planCode     => resource_attributes[:plan_code],
        :ccFirstName  => resource_attributes[:billing_first_name],
        :ccLastName   => resource_attributes[:billing_last_name],
        :ccNumber     => resource_attributes[:credit_card_number],
        :ccExpiration => resource_attributes[:credit_card_expiration],
        :ccZip        => resource_attributes[:billing_zip_code],
      }
    end

    def self.attributes_from_api(attributes)
      {
        :id                     => attributes['id'],
        :plan_code              => attributes['planCode'],
        :billing_first_name     => attributes['ccFirstName'],
        :billing_last_name      => attributes['ccLastName'],
        :credit_card_number     => attributes['ccNumber'],
        :credit_card_expiration => attributes['ccExpiration'],
        :billing_zip_code       => attributes['ccZip'],
      }
    end
  end
end
