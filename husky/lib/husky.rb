require "husky/version"
require "husky/array"
require "husky/routing"

module Husky
  class Application
    def call(env)
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(act)

      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end

  class Controller
    attr_accessor :env

    def initialize(env)
      self.env = env
    end
  end
end
