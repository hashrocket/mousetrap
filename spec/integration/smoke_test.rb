require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../../lib/mousetrap'
require 'yaml'
require 'activesupport'

Dir["#{File.dirname(__FILE__)}/../support/**/*.rb"].each {|f| require f}

settings = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')
Mousetrap.authenticate(settings['user'], settings['password'])
Mousetrap.product_code = settings['product_code']

describe "The Wrapper Gem" do
  it "works" do
    true.should be_true
  end
end
