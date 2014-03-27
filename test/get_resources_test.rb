require 'test_helper'

class GetResourcesTest < Minitest::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::Helpers

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    resource_1 = Resource.create(name: 'aResourceName', description: 'aResourceDescription')
    resource_2 = Resource.create(name: 'aResourceName', description: 'aResourceDescription')
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

  def assert_response_not_found
    assert_equal 404, last_response.status
  end

  def test_get_all_resource
    get '/resources'
    assert_response_ok
  end

  def test_json_resources
    server_response = get '/resources'
    assert_equal 200, last_response.status

    json = JSON.parse server_response.body

    assert resources = json['resources']
    pattern = {        
        resources: [
            name: String,
            description: String,
            links: Array, 
          ] * json['resources'].length,
        links: [
          rel: String,
          uri: String,
          ]
      }
    matcher = assert_json_match pattern, server_response.body
  end
end
