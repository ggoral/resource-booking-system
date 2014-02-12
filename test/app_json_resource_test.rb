require 'test_helper'

class AppJsonResourceTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
    @booking = @resource.bookings.create(start: Time.now.utc.iso8601.to_date , end: (Time.now.utc.iso8601.to_date+1), status: 'pending')
  end

  def teardown
    DatabaseCleaner.clean
  end

#  def test_json_resources
#    server_response = get '/resources'
#    assert_equal 200, last_response.status
#
#    json = JSON.parse server_response.body
#
#    assert resources = json['resources']
#    pattern = {        
#        resources: [
#            name: String,
#            description: String,
#            links: Array, 
#          ] * json['resources'].length,
#        links: [
#          rel: String,
#          uri: String,
#          ]
#      }
#    matcher = assert_json_match pattern, server_response.body
#  end
#
#  def test_json_first_resource
#    server_response = get "/resources/#{Resource.first.id}"
#    assert_equal 200, last_response.status
#
#    json = JSON.parse server_response.body
#    assert resource = json['resource']
#
#    resource = Resource.first
#    pattern = {        
#        resource: {
#            name: resource.name,
#            description: resource.description,
#            links:[
#              rel: String,
#              uri: String,
#              ] * json['resource']['links'].size 
#            }
#        }
#    matcher = assert_json_match pattern, server_response.body  
#  end
#

end