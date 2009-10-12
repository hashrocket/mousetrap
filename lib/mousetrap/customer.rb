module Mousetrap
  class Customer < Resource
    attr_accessor \
      :id,
      :code,
      :email,
      :first_name,
      :last_name,
      :subscription

    def subscription_attributes=(attributes)
      self.subscription = Subscription.new attributes
    end

    def attributes
      {
        :id         => id,
        :code       => code,
        :email      => email,
        :first_name => first_name,
        :last_name  => last_name,
      }
    end

    def attributes_for_api
      a = self.class.attributes_for_api(attributes, new_record?)

      if subscription
        a[:subscription] = subscription.attributes_for_api
      end

      a
    end

    def cancel
      member_action 'cancel' unless new_record?
    end

    def save
      new? ? create : update
    end

    def self.all
      response = get_resources plural_resource_name

      if response['error']
        if response['error'] == 'Resource not found: No customers found.'
          return []
        else
          raise response['error']
        end
      end

      build_resources_from response
    end

    def self.create(attributes)
      object = new(attributes)
      response = object.save
      returned_customer = build_resource_from response
      object.id = returned_customer.id
      # TODO: what other attrs to copy over?
      object
    end

    def self.new_from_api(attributes)
      customer = new(attributes_from_api(attributes))
      subscription_attrs = attributes['subscriptions']['subscription']
      customer.subscription = Subscription.new_from_api(subscription_attrs.kind_of?(Array) ? subscription_attrs.first : subscription_attrs)
      customer
    end


    protected

    def self.plural_resource_name
      'customers'
    end

    def self.singular_resource_name
      'customer'
    end

    def self.attributes_for_api(attributes, new_record = true)
      mutated_hash = {
        :email     => attributes[:email],
        :firstName => attributes[:first_name],
        :lastName  => attributes[:last_name],
      }
      mutated_hash.merge!(:code => attributes[:code]) if new_record
      mutated_hash
    end

    def self.attributes_from_api(attributes)
      {
        :id         => attributes['id'],
        :code       => attributes['code'],
        :first_name => attributes['firstName'],
        :last_name  => attributes['lastName'],
        :email      => attributes['email']
      }
    end

    def create
      response = self.class.post_resource 'customers', 'new', attributes_for_api

      raise response['error'] if response['error']

      returned_customer = self.class.build_resource_from response
      self.id = returned_customer.id
      response
    end

    def update
      self.class.put_resource 'customers', 'edit-customer', code, attributes_for_api
    end
  end
end
