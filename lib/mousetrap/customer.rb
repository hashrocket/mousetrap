module Mousetrap
  class Customer < Resource
    def self.all
      get_resources 'customers'
    end
    
    def self.create(hash)
      post_resource 'customers', 'new', hash
    end
  end
end
