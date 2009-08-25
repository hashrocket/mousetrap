module Mousetrap
  class Resource
    include HTTParty
    headers 'User-Agent' => 'Mousetrap Ruby Client'
    base_uri 'https://cheddargetter.com'

    def self.get_resources(resource)
      get "/xml/#{resource}/get/productCode/#{Mousetrap.product_code}"
    end

    def self.post_resource(resource, action, hash)
      post "/xml/#{resource}/#{action}/productCode/#{Mousetrap.product_code}", :body => hash
    end
  end
end
