module Mousetrap
  class Plan < Resource
    attr_accessor \
      :id,
      :code,
      :name


    protected

    def self.plural_resource_name
      'plans'
    end

    def self.singular_resource_name
      'plan'
    end

    def self.attributes_from_api(attributes)
      {
        :id   => attributes['id'],
        :code => attributes['code'],
        :name => attributes['name'],
      }
    end
  end
end
