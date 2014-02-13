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
    @booking = @resource.bookings.create(start: ("2013-10-26T10:00:00Z".to_time.utc.iso8601) , end: ("2013-10-26T11:00:00Z".to_time.utc.iso8601), status: 'pending')
    @booking.update(status: 'approved')
    @booking = @resource.bookings.create(start: "2013-10-26T11:00:00Z".to_time.utc.iso8601, end: ("2013-10-26T12:30:00Z".to_time.utc.iso8601), status: 'approved', user: 'otheruser@gmail.com')
    @booking_delete = @resource.bookings.create(start: "2013-10-26T11:00:00Z".to_time.utc.iso8601, end: ("2013-10-26T12:30:00Z".to_time.utc.iso8601), status: 'approved', user: 'otheruser@gmail.com')
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

  def test_assert_post_bookings_resource_without_params
    server_response = post "/resources/#{@resource.id}/bookings"
    assert_equal 400, last_response.status
  end

  def test_assert_post_bookings_resource_without_param_from
    server_response = post "/resources/#{@resource.id}/bookings?from=2014-03-03T01:00:00"
    assert_equal 400, last_response.status
  end

  def test_assert_post_bookings_resource_without_param_to
    server_response = post "/resources/#{@resource.id}/bookings?from=2014-03-03T01:00:00"
    assert_equal 400, last_response.status
  end

  def test_assert_post_bookings_resource_with_params
    server_response = post "/resources/#{@resource.id}/bookings?from=2011-03-03T01:00:00&to=2011-03-03T02:00:00"
    assert_equal 201, last_response.status
  end

  def test_assert_post_bookings_resource_with_conflict
    server_response = post "/resources/#{@resource.id}/bookings?from=2013-09-26T10:00:00Z&to=2013-11-26T11:00:01Z"
    assert_equal 409, last_response.status
  end

  def test_all_methods
    server_response = get "/resources/#{@resource.id}/availability"
    assert_equal 200, last_response.status

    server_response = put "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status

    server_response = get "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_equal 200, last_response.status

    server_response = delete "/resources/#{@resource.id}/bookings/#{@booking_delete.id}"
    assert_equal 200, last_response.status

  end

end
