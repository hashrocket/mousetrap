module Mousetrap
  class Customer < Resource
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
