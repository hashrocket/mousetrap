module Mousetrap
  class Plan < Resource
    attr_accessor :id
    attr_accessor :code
    attr_accessor :name


    protected

    def self.plural_resource_name
      'plans'
    end

    def self.singular_resource_name
      'plan'
    end

    def self.new_from_api(attributes_from_api)
      attributes = {
        :id   => attributes_from_api['id'],
        :code => attributes_from_api['code'],
        :name => attributes_from_api['name'],
      }

      new(attributes)
    end
  end
end
