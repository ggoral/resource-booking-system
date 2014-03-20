require 'test_helper'

class PutResourceTest < Minitest::Unit::TestCase
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

  def test_post_resources_invalid_parameter
    put '/resources/1?id=aResourceId'
    assert_response_bad_request
  end

  #def test_post_resources_valid_parameter
    #post '/resources?name=aResourceName'
    #assert_response_ok
  #end
#
#def test_post_resources_valid_parameters
    #post '/resources?name=aResourceName&description=aResourceDescription'
    #assert_response_ok
#end
#
#def test_post_resources_valid_parameter_with_invalid_parameter
    #post '/resources?name=aResourceName&parameter=aParameter'
    #assert_response_ok
#end
#
#def test_json_new_resource
    #server_response = post '/resources?name=aResourceName&description=aResourceDescription'
    #assert_equal 200, last_response.status
#
    #json = JSON.parse server_response.body
    #assert resource = json['resource']
#
    #pattern = {        
        #resource: {
            #name: 'aResourceName',
            #description: 'aResourceDescription',
            #links:[
              #rel: String,
              #uri: String,
              #] * json['resource']['links'].size 
            #}
        #}
    #matcher = assert_json_match pattern, server_response.body
  #end
#
end
