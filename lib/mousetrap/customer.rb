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

    def initialize(hash={})
      hash.each do |key, value|
        self.send("#{key}=", value)
      end
    end

    def new_record?
      id.nil?
    end

    def save!
      raise "code must not be blank" if code.nil?

      if new_record?
        self.class.create attributes_for_api
      else
        self.class.put_resource 'customers', 'edit-customer', code, attributes_for_api
      end
    end

    def self.all
      get_resources 'customers'
    end

    def self.create(hash)
      response = post_resource('customers', 'new', attributes_for_api(hash))
      build_existing_record response
    end

    def self.[](code)
      response = get_resource('customers', code)
      build_existing_record response
    end


    protected

    def self.build_existing_record(response)
      customer_hash = response['customers']['customer']

      attributes = {
        :id => customer_hash['id'],
        :code => customer_hash['code'],
        :first_name => customer_hash['firstName'],
        :last_name => customer_hash['lastName'],
        :email => customer_hash['email']
      }

      customer = new(attributes)
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
