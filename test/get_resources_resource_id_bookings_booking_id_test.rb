require 'test_helper'

class GetResourcesResourceIdBookingsBookingIdTest < Minitest::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::Helpers

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    resource = Resource.create(name: 'aResourceName', description: 'aResourceDescription')
    booking = resource.bookings.create(start: Time.now.utc.iso8601.to_date , end: (Time.now.utc.iso8601.to_date+1), status: 'pending')
    booking = resource.bookings.create(start: Time.now.utc.iso8601.to_date , end: (Time.now.utc.iso8601.to_date+1), status: 'pending')
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_get_resources_booking
    get "/resources/#{Resource.first.id}/bookings/#{Resource.first.bookings.first.id}"
    assert_equal 200, last_response.status
  end

  def test_json_get_booking
      resource = Resource.first
      booking = Resource.first.bookings.first
      post "/resources/#{@resource.id}/bookings?from=2014-05-15T00:00:00Z&to=2014-06-15T23:59:59Z"
      server_response = get "/resources/#{resource.id}/bookings/#{booking.id}"
      assert_equal 200, last_response.status
      
      json = JSON.parse server_response.body
      assert booking = json
      
      pattern = {        
        from: String,
        to: String,
        status: booking['status'],
        links:[
          {  
            rel: "self",
            uri: String 
          },
          {  
            rel: "resource",
            uri: String
          },
          {  
            rel: "accept",
            uri: String,
            method: "PUT"
          },
          {  
            rel: "reject",
            uri: String, 
            method: "DELETE"
          }
      ]  
    }
    matcher = assert_json_match pattern, server_response.body  
  end
end
