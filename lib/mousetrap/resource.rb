module Mousetrap
  class Resource
    include HTTParty
    headers 'User-Agent' => 'Mousetrap Ruby Client'
    base_uri 'https://cheddargetter.com'

    def self.delete_resource(resource, code)
      path = "/xml/#{resource}/delete/productCode/#{Mousetrap.product_code}/code/#{code}"
      post path
    end

    def self.get_resource(resource, code)
      get "/xml/#{resource}/get/productCode/#{Mousetrap.product_code}/code/#{code}"
    end

    def self.get_resources(resource)
      get "/xml/#{resource}/get/productCode/#{Mousetrap.product_code}"
    end

    def self.post_resource(resource, action, hash)
      post "/xml/#{resource}/#{action}/productCode/#{Mousetrap.product_code}", :body => hash
    end

    def self.put_resource(resource, action, resource_code, hash)
      path = "/xml/#{resource}/#{action}/productCode/#{Mousetrap.product_code}/code/#{resource_code}"
      post path, :body => hash
    end
  end
end
