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

  def test_get_root
    get '/'
    assert_content_type_is_json last_response
    assert_equal 200, last_response.status
  end

  def test_json_resources
    server_response = get '/'
    assert_content_type_is_json last_response
    assert_equal 200, last_response.status

    json = JSON.parse server_response.body

    assert url = json
    pattern = {        
        url: "http://example.org/"
    }
    p json
    matcher = assert_json_match pattern, server_response.body
  end
end
