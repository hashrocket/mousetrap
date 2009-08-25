module Mousetrap
  class Customer < Resource
    attr_accessor :code
    attr_accessor :email
    attr_accessor :first_name
    attr_accessor :last_name
    
    alias_method :firstName,  :first_name
    alias_method :firstName=, :first_name=
    alias_method :lastName,   :last_name
    alias_method :lastName=,  :last_name=
        
    def initialize(hash)
      hash.each do |key, value|
        self.send("#{key}=", value)
      end
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
      post_resource 'customers', 'new', hash
    end

    def self.[](code)
      get_resource 'customers', code
    end    
  end
end
