require 'test_helper'

class AppJsonExpressionsTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
    @booking = @resource.bookings.create(start: ("2013-10-26 10:00:00".to_time.utc.iso8601) , end: ("2013-10-26 11:00:00".to_time.utc.iso8601), status: 'pending')
    @booking.update(status: 'approved')
    @booking = @resource.bookings.create(start: "2013-10-26T11:00:00Z".to_time.utc.iso8601, end: ("2013-10-26T12:30:00Z".to_time.utc.iso8601), status: 'approved', user: 'otheruser@gmail.com')
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_json_booking
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

def test_json_post_booking
      server_response = post "/resources/#{@resource.id}/bookings?from=2014-03-03T01:00:00&to=2014-03-03T02:00:00"
      assert_equal 201, last_response.status

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