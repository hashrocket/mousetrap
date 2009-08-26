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
      path = "/xml/#{resource}/get/productCode/#{Mousetrap.product_code}/code/#{code}"
      get path
    end

    def self.get_resources(resource)
      path = "/xml/#{resource}/get/productCode/#{Mousetrap.product_code}"
      get path
    end

    def self.post_resource(resource, action, attributes)
      path = "/xml/#{resource}/#{action}/productCode/#{Mousetrap.product_code}"
      post path, :body => attributes
    end

    def self.put_resource(resource, action, resource_code, attributes)
      path = "/xml/#{resource}/#{action}/productCode/#{Mousetrap.product_code}/code/#{resource_code}"
      post path, :body => attributes
    end
  end
end
