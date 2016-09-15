require_relative 'test_helper'

class HuskyTest < Minitest::Test
  include Rack::Test::Methods

  def test_that_it_has_a_version_number
    refute_nil ::Husky::VERSION
  end

  def app
    Husky::Application.new
  end

  def test_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["husky!"]
  end
end
