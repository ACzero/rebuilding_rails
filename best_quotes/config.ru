# see http://rack.github.io/

require './config/application'

# use Rack::Auth::Basic, "app" do |_, pass|
#   'secret' == pass
# end

# class Canadianize
#   def initialize(app, arg = "")
#     @app = app
#     @arg = arg
#   end

#   def call(env)
#     status, headers, content = @app.call(env)
#     content[0] += @arg + ", eh?"
#     [status, headers, content]
#   end
# end

# use Canadianize, ", simple"

require "rack/lobster"


class BenchMarker
  def initialize(app, runs = 100)
    @app, @runs = app, runs
  end

  def call(env)
    t = Time.now

    result = nil
    @runs.times { result = @app.call(env) }

    t2 = Time.now - t
    STDERR.puts <<-OUTPUT
Benchmark:
  #{@runs} runs
  #{t2.to_f} seconds total
  #{t2.to_f * 1000.0 / @runs} millisec/run
OUTPUT

    result
  end
end

# map "/lobster" do
#   use Rack::ShowExceptions
#   run Rack::Lobster.new
# end

# map "/lobster/but_not" do
#   run proc {
#     [200, {}, ["Really not a lobster"]]
#   }
# end

# use Rack::ContentType
# use BenchMarker, 10_000
# run Rack::Lobster.new

# run proc {
#   p "call proc"
#   [200, {'Content-Type' => 'text/html'}, ["Hello, world"]]
# }

app = BestQuotes::Application.new

use Rack::ContentType

app.route do
  root "quotes#index"
  match "*/test"
  match "sub-app",
    proc { [200, {}, ["Hello, sub-app"]] }

  # default routes
  match ":controller/:id/:action"
  match ":controller/:id",
    :default => { "action" => "show" }
  match ":controller",
    :default => { "action" => "index" }
end

run app
