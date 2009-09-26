require File.expand_path('../../../lib/mousetrap', __FILE__)

require 'spec'
require 'spec/autorun'
require 'factory_girl'
require 'active_support'
require 'yaml'

Dir["#{File.dirname(__FILE__)}/../support/**/*.rb"].each {|f| require f}

settings = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')
Mousetrap.authenticate(settings['user'], settings['password'])
Mousetrap.product_code = settings['product_code']

Spec::Runner.configure do |config|
  config.before :suite do
    begin
      Mousetrap::Customer.destroy_all
    rescue
    end
  end
end

describe "The Wrapper Gem" do
  it "works" do
    true.should be_true
  end
end
