require 'test_helper'

class PutResourcesResourceIdTest < Minitest::Unit::TestCase
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

  def test_put_a_resources_without_resource_id
    put '/resources/'
    assert_response_not_found
  end
  
  def test_put_a_resources_without_parameter
    put '/resources/1'
    assert_response_bad_request
  end

  def test_put_resources_invalid_parameter
    put '/resources/1?id=aResourceId'
    assert_response_bad_request
  end

  def test_put_resources_valid_parameter_name
    put '/resources/1?name=aResourceName'
    assert_response_ok
  end

  def test_put_resources_valid_parameter_description
    put '/resources/1?description=aResourceDescription'
    assert_response_ok
  end

  def test_put_resources_valid_parameters
      put '/resources/1?name=aResourceName&description=aResourceDescription'
      assert_response_ok
  end

  def test_put_resources_valid_parameter_with_invalid_parameter
     put '/resources/1?name=aResourceName&parameter=aParameter'
     assert_response_ok
  end

  def test_json_update_resource
    server_response = put '/resources/1?name=aNewResourceName&description=aNewResourceDescription'
    json = JSON.parse server_response.body
    
    assert resource = json['resource']
  
    pattern = {        
        resource: {
            name: 'aNewResourceName',
            description: 'aNewResourceDescription',
            links:[
              rel: String,
              uri: String,
              ] * json['resource']['links'].size 
            }
        }
    matcher = assert_json_match pattern, server_response.body
  end

end
