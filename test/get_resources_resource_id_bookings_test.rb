require 'test_helper'

class GetResourcesResourceIdBookingsTest < Minitest::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::Helpers

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    resource = Resource.create(name: 'aResourceName', description: 'aResourceDescription')
    booking = resource.bookings.create(start: (Time.now.utc.iso8601.to_date + 1), end: (Time.now.utc.iso8601.to_date+3), status: 'pending')
    booking.update(status: 'approved')
    booking = resource.bookings.create(start: (Time.now.utc.iso8601.to_date + 1), end: (Time.now.utc.iso8601.to_date+3), status: 'pending')
    booking.update(status: 'approved')
  end

  def teardown
    DatabaseCleaner.clean
  end

  def assert_response_ok
    assert_equal 200, last_response.status
  end

  def assert_response_created
    assert_equal 201, last_response.status
  end

  def assert_response_bad_request
    assert_equal 400, last_response.status
  end

  def assert_response_not_found
    assert_equal 404, last_response.status
  end

  def assert_response_conflict
    assert_equal 409, last_response.status
  end

  def test_get_resource_bookings
    get "/resources/#{Resource.first.id}/bookings"
    assert_response_ok
  end

   def test_assert_post_bookings_resource_with_conflict
    get "/resources/#{Resource.first.id}/bookings?from=2013-09-26T10:00:00Z&to=2013-11-26T11:00:01Z"
    assert_response_ok
  end

  def test_json_get_booking
      resource = Resource.first
      booking = Resource.first.bookings
      server_response = get "/resources/#{resource.id}/bookings"
      assert_equal 200, last_response.status
      
      json = JSON.parse server_response.body
      
      pattern = {
        bookings: [       
          from: String,
          to: String,
          status: String,
          user: wildcard_matcher,
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
        ] * booking.length,
        links: [
          rel: String,
          uri: String,
          ]
    }
    matcher = assert_json_match pattern, server_response.body  
  end
end
