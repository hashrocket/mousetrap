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

describe "The Wrapper Gem" do
  it "works" do
    true.should be_true
  end
end
