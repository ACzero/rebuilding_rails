require 'erubis'
require "husky/file_model"

module Husky
  class Controller
    include Husky::Model

    attr_accessor :env
    attr_accessor :routing_params

    def initialize(env)
      self.env = env
      self.routing_params = {}
    end

    def dispatch(action, routing_params = {})
      self.routing_params = routing_params

      err = false
      text = begin
               self.send(action)
             rescue Exception => e
               err = true
               msg = e.backtrace.join("\n")
               "#{__FILE__} #{__LINE__}:#{e.message}" +
                 "\n#{msg}"
             end

      if err
        [200,
          {'Content-Type' => 'text/html'}, [text]]
      else
        begin
          self.get_response || self.render(action.intern)
        rescue
          raise "Template Missing" unless controller.get_response
        end

        st, hd, rs = controller.get_response.to_a
        [st, hd, [rs.body].flatten]
      end
    end

    def self.action(act, rp = {})
      proc { |e| self.new(e).dispatch(act, rp) }
    end

    def render_base(view_name)
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

    def request
      @request ||= Rack::Request.new(self.env)
    end

    def params
      request.params.merge self.routing_params
    end

    def response(text, status = 200, headers = {})
      raise "Already responed!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render(*args)
      response(render_base(*args))
    end
  end
end
