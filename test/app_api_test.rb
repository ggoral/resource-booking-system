require 'test_helper'

class AppApiTest < Minitest::Unit::TestCase
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

  def test_assert_get_resources
    server_response = get '/resources'
    assert_equal 200, last_response.status
  end

  def test_assert_get_one_resource
    server_response = get "/resources/#{@resource.id}"
    assert_equal 200, last_response.status
  end

  def test_fail_get_non_existent_resource
    server_response = get "/resources/#{Resource.last.id.to_i + 1}"
    assert_equal 404, last_response.status
  end

  def test_assert_get_all_bookings_resource_without_params
    server_response = get "/resources/#{@resource.id}/bookings"
    assert_equal 200, last_response.status
  end

  def test_assert_get_all_bookings_resource_with_non_existent_resource
    server_response = get "/resources/#{Resource.last.id.to_i + 1}/bookings"
    assert_equal 404, last_response.status
  end

  def test_assert_get_all_bookings_resource_with_params
    server_response = get "/resources/#{@resource.id}/bookings?date=2013-10-26&limit=365&status=pending"
    assert_equal 200, last_response.status
  end

  def test_assert_get_all_bookings_resource_with_param_limit
    server_response = get "/resources/#{@resource.id}/bookings?limit=1"
    assert_equal 200, last_response.status
  end

  def test_assert_get_all_bookings_resource_with_param_date
    server_response = get "/resources/#{@resource.id}/bookings?date=2013-10-26"
    assert_equal 200, last_response.status
  end

  def test_assert_get_all_bookings_resource_with_param_status
    server_response = get "/resources/#{@resource.id}/bookings?status=pending"
    assert_equal 200, last_response.status
  end

  def test_fail_get_all_bookings_resource_with_param_limit_invalid
    server_response = get "/resources/#{@resource.id}/bookings?date=2013-10-26&limit=366&status=pending"
    assert_equal 400, last_response.status
  end

  def test_all_methods
    server_response = get "/resources/#{@resource.id}/availability"
    assert_equal 200, last_response.status

    server_response = delete "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status

    server_response = put "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status

    server_response = get "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status
  end

end
