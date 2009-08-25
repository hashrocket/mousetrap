class Mousetrap::Client
  include HTTParty
  headers 'User-Agent' => 'Mousetrap Ruby Client'
  base_uri 'https://cheddargetter.com'

  attr_reader :product_code

  def initialize(username, password, product_code)
    self.class.basic_auth username, password
    @product_code = product_code
  end

  def customers
    get 'customers'
  end

  protected

  def get(resource)
    self.class.get "/xml/#{resource}/get/productCode/#{product_code}"
  end
end
