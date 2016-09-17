require "husky/version"
require "husky/array"
require "husky/routing"
require "husky/util"
require "husky/dependencies"
require "husky/controller"
require "husky/file_model"

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
      rack_app = klass.action(act)
      rack_app.call(env)

      # controller = klass.new(env)
      # err = false
      # text = begin
      #          controller.send(act)
      #        rescue Exception => e
      #          err = true
      #          msg = e.backtrace.join("\n")
      #          "#{__FILE__} #{__LINE__}:#{e.message}" +
      #            "\n#{msg}"
      #        end

      # if err
      #   [200,
      #     {'Content-Type' => 'text/html'}, [text]]
      # else
      #   begin
      #     controller.get_response || controller.render(act.intern)
      #   rescue
      #     raise "Template Missing" unless controller.get_response
      #   end

      #   st, hd, rs = controller.get_response.to_a
      #   [st, hd, [rs.body].flatten]
      # end
    end
  end
end
