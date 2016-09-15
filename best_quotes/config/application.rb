require 'husky'

module BestQuotes
  class Application < Husky::Application
    def call(env)
      test = [1,2,3]
      [200, {'Content-Type' => 'text/html'}, [test.sum(0).to_s]]
    end
  end
end
