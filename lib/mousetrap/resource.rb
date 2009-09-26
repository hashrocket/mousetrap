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

    def self.[](code)
      response = get_resource plural_resource_name, code
      build_resource_from response
    end

    def self.all
      response = get_resources plural_resource_name
      build_resources_from response
    end

    def self.create(attributes = {})
      raise NotImplementedError, NO_BUSINESS_NEED
    end

    def self.delete(code)
      raise NotImplementedError, NO_BUSINESS_NEED
    end

    def self.exists?(code)
      raise NotImplementedError, NO_BUSINESS_NEED
    end

    def destroy
      raise NotImplementedError, NO_BUSINESS_NEED
    end

    def exists?(code)
      raise NotImplementedError, NO_BUSINESS_NEED
    end

    def new?
      id.nil?
    end

    alias new_record? new?

    def self.new_from_api(attributes)
      new(attributes_from_api(attributes))
    end

    def save
      raise NotImplementedError, NO_BUSINESS_NEED
    end


    protected

    def self.cancel_resource(resource, code)
      path = "/xml/#{resource}/cancel/productCode/#{Mousetrap.product_code}/code/#{code}"
      post path
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

    def self.plural_resource_name
      raise 'You must implement self.plural_resource_name in your subclass.'
    end

    def self.singular_resource_name
      raise 'You must implement self.singular_resource_name in your subclass.'
    end

    def self.build_resource_from(response)
      resource_attributes = extract_resources(response)
      new_from_api(resource_attributes)
    end

    def self.build_resources_from(response)
      resources = []

      response_resources = extract_resources(response)

      if response_resources.is_a?(Array)
        extract_resources(response).each do |resource_attributes|
          resources << new_from_api(resource_attributes)
        end
      else
        resources << new_from_api(response_resources)
      end

      resources
    end

    def self.extract_resources(response)
      response[plural_resource_name][singular_resource_name]
    end
  end
end
