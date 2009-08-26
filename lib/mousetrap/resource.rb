module Mousetrap
  class Resource
    include HTTParty
    headers 'User-Agent' => 'Mousetrap Ruby Client'
    base_uri 'https://cheddargetter.com'

    def initialize(hash={})
      hash.each do |key, value|
        self.send("#{key}=", value)
      end
    end

    def self.all
      response = get_resources plural_resource_name
      build_resources_from response
    end

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


    protected

    def self.build_resource_from(response)
      attributes = extract_resources(response)
      new_from_api(attributes)
    end

    def self.build_resources_from(response)
      resources = []
      extract_resources(response).each do |customer_hash|
        resources << new_from_api(customer_hash)
      end
      resources
    end

    def self.extract_resources(response)
      response[plural_resource_name][singular_resource_name]
    end
  end
end
