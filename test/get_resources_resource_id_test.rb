require 'test_helper'

class GetResourcesResourceIdTest < Minitest::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::Helpers

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @resource = Resource.create(name: 'aResourceName', description: 'aResourceDescription')
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

  def test_get_a_resource_without_resource_id
    get '/resources/'
    assert_response_not_found
  end
  
  def test_get_a_resource
    get '/resources/1'
    assert_response_ok
  end

  def test_get_an_non_existent_resource
    get "/resources/#{Resource.last.id.to_i.next}"
    assert_response_not_found
  end
end
