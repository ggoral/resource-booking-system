require 'test_helper'

class ResourceTest < Minitest::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::Helpers

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def assert_response_ok
    assert_equal 200, last_response.status
  end

  def assert_response_bad_request
    assert_equal 400, last_response.status
  end

  def test_post_resources_without_parameters
    post '/resources'
    assert_response_bad_request
  end
  
  def test_post_resources_invalid_parameter
    post '/resources?id=aResourceName'
    assert_response_bad_request
  end

  def test_post_resources_valid_parameter
    post '/resources?name=aResourceName'
    assert_response_ok
  end

end
