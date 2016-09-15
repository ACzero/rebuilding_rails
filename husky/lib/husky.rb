require "husky/version"

module Husky
  class Application
    def call(env)
      [200, {'Content-Type' => 'text/html'}, ["husky!"]]
    end
  end
end
