class RouteObject
  def initialize
    @husky = []
  end

  def match(url, *args)
  end

  def check_url(url)
  end
end

module Husky
  class Application
    def get_controller_and_action(env)
      _, cont, action, after =
        env["PATH_INFO"].split('/', 4)

      cont = cont.capitalize
      cont += "Controller"

      [Object.const_get(cont), action]
    end

    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
    end

    def get_rack_app(env)
      raise "No routes!" unless @route_obj
      @route_obj.check_url(env["PATH_INFO"])
    end
  end
end
