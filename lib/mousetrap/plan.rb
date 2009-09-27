module Mousetrap
  class Plan < Resource
    attr_accessor \
      :id,
      :code,
      :name

    def self.all
      response = get_resources plural_resource_name
      return [] unless response['plans']
      build_resources_from response
    end

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
