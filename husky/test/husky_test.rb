require_relative 'test_helper'

class TestController < Husky::Controller
  def index
    "Hello!"
  end
end

class TestApp < Husky::Application
  def get_controller_and_action(env)
    [TestController, "index"]
  end
end

class HuskyTest < Minitest::Test
  include Rack::Test::Methods

  def test_that_it_has_a_version_number
    refute_nil ::Husky::VERSION
  end

  def app
    TestApp.new
  end

  def test_request
    get "/example/route"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end
end
