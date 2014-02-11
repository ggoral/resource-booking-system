require 'test_helper'

class AppTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
    @booking = @resource.bookings.create(start: Date.today, end: (Date.today+1), status: 'pending')
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_all_methods
    server_response = get '/resources'
    assert_equal 200, last_response.status

    server_response = get "/resources/#{@resource.id}"
    assert_equal 200, last_response.status

    server_response = get "/resources/#{@resource.id}/bookings"
    assert_equal 200, last_response.status

    server_response = get "/resources/#{@resource.id}/availability"
    assert_equal 200, last_response.status

    server_response = post "/resources/#{@resource.id}/bookings"
    assert_equal 200, last_response.status

    server_response = delete "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status

    server_response = put "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status

    server_response = get "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status
  end

end
