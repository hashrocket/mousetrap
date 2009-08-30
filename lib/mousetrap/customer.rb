module Mousetrap
  class Customer < Resource
    attr_accessor :id
    attr_accessor :code
    attr_accessor :email
    attr_accessor :first_name
    attr_accessor :last_name

    def attributes
      {
        :id => id,
        :code => code,
        :email => email,
        :first_name => first_name,
        :last_name => last_name,
      }
    end

    def destroy
      self.class.delete_resource('customers', code) unless new_record?
    end

    def save!
      raise "code must not be blank" if code.nil?

      if new_record?
        self.class.create attributes_for_api
      else
        self.class.put_resource 'customers', 'edit-customer', code, attributes_for_api
      end
    end

    def self.create(hash)
      response = post_resource('customers', 'new', attributes_for_api(hash))
      build_resource_from response
    end


    protected

    def self.plural_resource_name
      'customers'
    end

    def self.singular_resource_name
      'customer'
    end

    def self.new_from_api(attributes_from_api)
      attributes = {
        :id         => attributes_from_api['id'],
        :code       => attributes_from_api['code'],
        :first_name => attributes_from_api['firstName'],
        :last_name  => attributes_from_api['lastName'],
        :email      => attributes_from_api['email']
      }

      new(attributes)
    end

    def self.attributes_for_api(hash, new_record = true)
      mutated_hash = {
        :email => hash[:email],
        :firstName => hash[:first_name],
        :lastName => hash[:last_name],
      }
      mutated_hash.merge!(:code => hash[:code]) if new_record
      mutated_hash
    end

    def attributes_for_api
      self.class.attributes_for_api(attributes, new_record?)
    end
  end
end
