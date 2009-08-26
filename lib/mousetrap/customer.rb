module Mousetrap
  class Customer < Resource
    attr_accessor :code
    attr_accessor :email
    attr_accessor :first_name
    attr_accessor :last_name
    attr_accessor :id

    def initialize(hash={})
      hash.each do |key, value|
        self.send("#{key}=", value)
      end
    end

    def new_record?
      id.nil?
    end

    def save!
      # TODO:  Not truly same semantics as ActiveRecord's save, because
      # it doesn't create, it only updates right now.
      hash = {:firstName => first_name,
              :lastName  => last_name,
              :email     => email }

      raise "code must not be blank" if code.nil?
      self.class.put_resource 'customers', 'edit-customer', code, hash
    end

    def self.all
      get_resources 'customers'
    end

    def self.create(hash)
      response_hash = post_resource('customers', 'new', hash)
      build_existing_record response_hash
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
  end
end
