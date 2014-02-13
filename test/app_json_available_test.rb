require 'test_helper'

class AppJsonAvailabilityTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
    @booking = @resource.bookings.create(start: ("2013-10-12T00:00:00Z".to_time.utc.iso8601) , end: ("2013-11-26T10:00:00Z".to_time.utc.iso8601), status: 'pending')
    @booking.update(status: 'approved')
    @booking = @resource.bookings.create(start: "2013-10-26T11:00:00Z".to_time.utc.iso8601, end: ("2013-10-26T12:30:00Z".to_time.utc.iso8601), status: 'approved', user: 'otheruser@gmail.com')
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_json_availability
    server_response = get "/resources/#{@resource.id}/availability?date=2013-10-20&limit=30"
    assert_equal 200, last_response.status
    
    json = JSON.parse server_response.body
    assert available = json
    
    available = @resource.periods_availables(
      "2013-10-20T11:00:00Z".to_time.utc.iso8601, 
      "2013-10-26T11:00:00Z".to_time.utc.iso8601
      )

    pattern = {
      availables: [
        from: String,
        to: String,
        links: Array
        ] * available.size,
      links: Array
      }
    matcher = assert_json_match pattern, server_response.body  
  end

  def test_json_bookings
    server_response = get "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status
    json = JSON.parse server_response.body
    assert booking = json
    
    booking = @booking
    pattern = {        
      from: String,
      to: String,
      status: booking.status,
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