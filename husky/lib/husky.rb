require "husky/version"
require "husky/array"
require "husky/routing"
require "husky/util"
require "husky/dependencies"
require "husky/controller"


module Husky
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404,
          {'Content-Type' => 'text/html'}, []]
      elsif env['PATH_INFO'] == '/'
        return [302,
          {'Location' => 'https://www.google.com'}, []]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      text = begin
               controller.send(act)
             rescue Exception => e
               msg = e.backtrace.join("\n")
               "#{__FILE__} #{__LINE__}:#{e.message}" +
                 "\n#{msg}"
             end

      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end
end
