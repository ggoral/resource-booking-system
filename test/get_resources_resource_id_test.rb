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
    @booking = @resource.bookings.create(start: Time.now.utc.iso8601.to_date , end: (Time.now.utc.iso8601.to_date+1), status: 'pending')

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
    get "/resources/#{Resource.first.id}"
    assert_response_ok
  end

  def test_get_an_non_existent_resource
    get "/resources/#{Resource.last.id.to_i.next}"
    assert_response_not_found
  end

  def test_json_first_resource
    server_response = get "/resources/#{Resource.first.id}"
    assert_equal 200, last_response.status

    json = JSON.parse server_response.body
    assert resource = json['resource']

    resource = Resource.first
    pattern = {        
        resource: {
            name: resource.name,
            description: resource.description,
            links:[
              rel: String,
              uri: String,
              ] * json['resource']['links'].size 
            }
        }
    matcher = assert_json_match pattern, server_response.body  
  end
end
