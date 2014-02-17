require 'test_helper'

class AppTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def assert_content_type_is_json(response)
    content_type = response.headers['Content-Type']
    assert_equal 'application/json;charset=utf-8', content_type
  end

  def test_get_resources
    get '/resources'
    assert_content_type_is_json last_response
    assert_equal 200, last_response.status
  end
  
end
