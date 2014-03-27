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
    booking = resource.bookings.create(start: Time.now.utc.iso8601.to_date , end: (Time.now.utc.iso8601.to_date+1), status: 'pending')
    booking = resource.bookings.create(start: Time.now.utc.iso8601.to_date , end: (Time.now.utc.iso8601.to_date+1), status: 'pending')

#    @resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
#    @booking = @resource.bookings.create(start: ("2013-10-26T10:00:00Z".to_time.utc.iso8601) , end: ("2013-10-26T11:00:00Z".to_time.utc.iso8601), status: 'pending')
#    @booking.update(status: 'approved')
#    @booking = @resource.bookings.create(start: "2013-10-26T11:00:00Z".to_time.utc.iso8601, end: ("2013-10-26T12:30:00Z".to_time.utc.iso8601), status: 'approved', user: 'otheruser@gmail.com')
#    @booking_delete = @resource.bookings.create(start: "2013-10-26T11:00:00Z".to_time.utc.iso8601, end: ("2013-10-26T12:30:00Z".to_time.utc.iso8601), status: 'approved', user: 'otheruser@gmail.com')

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

  def assert_get_resource(verb)
    get "/resources/#{Resource.first.id}/#{verb}"
    assert_response_ok
  end

  def assert_non_existent_resource(verb)
    get "/resources/#{Resource.last.id.to_i + 1}/#{verb}"
    assert_response_not_found
  end

  def assert_get_resources_with_date_limit_status(verb, date=nil, limit=nil, status=nil)
    get "/resources/#{Resource.first.id}/#{verb}?date=#{date}&limit=#{limit}&status=#{status}"
    assert_response_ok
  end

  def refute_get_resources_with_date_limit_status(verb, date=nil, limit=nil, status=nil)
    get "/resources/#{Resource.first.id}/#{verb}?date=#{date}&limit=#{limit}&status=#{status}"
    assert_response_bad_request
  end

  def assert_get_resources_with_date(verb, date=nil)
    get "/resources/#{Resource.first.id}/#{verb}?date=#{date}"
    assert_response_ok
  end

  def assert_get_resources_with_limit(verb, limit=nil)
    get "/resources/#{Resource.first.id}/#{verb}?limit=#{limit}"
    assert_response_ok
  end

  def assert_get_resources_with_status(verb, status=nil)
    get "/resources/#{Resource.first.id}/#{verb}?status=#{status}"
    assert_response_ok
  end

  def test_get_resource
    assert_get_resource 'bookings'
  end

  def test_non_existent_resource
    assert_non_existent_resource 'bookings'
  end

  def test_get_resources_with_date_limit_status
    assert_get_resources_with_date_limit_status('bookings', '2013-10-26','365', 'pending')
  end

  def test_get_resources_with_date_limit_status
    refute_get_resources_with_date_limit_status('bookings', '2013-10-26','366', 'pending')
  end
  
  def test_get_resources_with_date
    assert_get_resources_with_date('bookings','2013-10-26')
  end
  
  def test_get_resources_with_limit
    assert_get_resources_with_limit('bookings','1')
  end
  
  def test_get_resources_with_status
    assert_get_resources_with_status('bookings','pending')
  end
  
  def test_put_resources_booking
    put "/resources/#{Resource.first.id}/bookings/#{Resource.first.bookings.first.id}"
    assert_response_ok
  end

  def test_get_resources_booking
    get "/resources/#{Resource.first.id}/bookings/#{Resource.first.bookings.first.id}"
    assert_response_ok
  end

  def test_delete_resources_booking
    delete "/resources/#{Resource.first.id}/bookings/#{Resource.first.bookings.last.id}"
    assert_response_ok
  end

  def test_json_get_booking
      resource = Resource.first
      booking = Resource.first.bookings.first

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
