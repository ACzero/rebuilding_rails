require 'erubis'

module Husky
  class Controller
    attr_accessor :env

    def initialize(env)
      self.env = env
    end

    def render(view_name, locals = {})
      filename = File.join("app", "views", controller_name,
                           "#{view_name}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      eruby.result(locals.merge(env: env))
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, '')
      Husky.to_underscore(klass)
    end
  end
end
