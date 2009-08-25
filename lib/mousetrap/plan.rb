module Mousetrap
  class Plan < Resource
    def self.all
      get_resources 'plans'
    end

    def self.[](code)
      get_resource 'plans', code
    end
  end
end
