require 'erubis'
require "husky/file_model"

module Husky
  class Controller
    include Husky::Model

    attr_accessor :env

    def initialize(env)
      self.env = env
    end

    def render(view_name)
      filename = File.join("app", "views", controller_name,
                           "#{view_name}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      eruby.result(instance_variables_hash.merge(env: env))
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, '')
      Husky.to_underscore(klass)
    end

    def instance_variables_hash
      result = {}
      self.instance_variables.each do |iv|
        result[iv] = self.instance_variable_get(iv)
      end

      result
    end
  end
end
