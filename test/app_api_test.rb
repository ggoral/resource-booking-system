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


  def test_assert_get_resources
    get '/resources'
    assert_response_ok 
  end

  def test_assert_get_one_resource
    get "/resources/#{@resource.id}"
    assert_response_ok
  end

  def test_fail_get_non_existent_resource
    get "/resources/#{Resource.last.id.to_i + 1}"
    assert_response_not_found
  end

  def assert_get_resource(verb)
    get "/resources/#{@resource.id}/#{verb}"
    assert_response_ok
  end

  def test_assert_get_resource
    assert_get_resource 'bookings'
    assert_get_resource 'availability'
  end

  def assert_non_existent_resource(verb)
    get "/resources/#{Resource.last.id.to_i + 1}/#{verb}"
    assert_response_not_found
  end

  def test_non_existent_resource
    assert_non_existent_resource 'bookings'
    assert_non_existent_resource 'availability'
  end

  def assert_get_resources_with_date_limit_status(verb, date=nil, limit=nil, status=nil)
    get "/resources/#{@resource.id}/#{verb}?date=#{date}&limit=#{limit}&status=#{status}"
    assert_response_ok
  end

  def refute_get_resources_with_date_limit_status(verb, date=nil, limit=nil, status=nil)
    get "/resources/#{@resource.id}/#{verb}?date=#{date}&limit=#{limit}&status=#{status}"
    assert_response_bad_request
  end

  def assert_get_resources_with_date(verb, date=nil)
    get "/resources/#{@resource.id}/#{verb}?date=#{date}"
    assert_response_ok
  end

  def assert_get_resources_with_limit(verb, limit=nil)
    get "/resources/#{@resource.id}/#{verb}?limit=#{limit}"
    assert_response_ok
  end

  def assert_get_resources_with_status(verb, status=nil)
    get "/resources/#{@resource.id}/#{verb}?status=#{status}"
    assert_response_ok
  end

  def test_assert_get_all_bookings_resource_with_params
    assert_get_resources_with_date_limit_status('bookings', '2013-10-26','365', 'pending')
    assert_get_resources_with_date_limit_status('availability', '2013-10-26','365', 'pending')

    refute_get_resources_with_date_limit_status('bookings', '2013-10-26','366', 'pending')
    refute_get_resources_with_date_limit_status('availability', '2013-10-26','366', 'pending')

    assert_get_resources_with_date('bookings','2013-10-26')
    assert_get_resources_with_date('availability','2013-10-26')

    assert_get_resources_with_limit('bookings','1')
    assert_get_resources_with_limit('availability','1')

    assert_get_resources_with_status('bookings','pending')
    assert_get_resources_with_status('availability','pending')
  end

  def test_fail_get_all_bookings_resource_with_param_limit_invalid
    get "/resources/#{@resource.id}/bookings?date=2013-10-26&limit=366&status=pending"
    assert_response_bad_request
  end

  def test_assert_post_bookings_resource_without_params
    post "/resources/#{@resource.id}/bookings"
    assert_response_bad_request
  end

  def test_assert_post_bookings_resource_without_param_from
    post "/resources/#{@resource.id}/bookings?from=2014-03-03T01:00:00"
    assert_response_bad_request
  end

  def test_assert_post_bookings_resource_without_param_to
    post "/resources/#{@resource.id}/bookings?from=2014-03-03T01:00:00"
    assert_response_bad_request
  end

  def test_assert_post_bookings_resource_with_params
    post "/resources/#{@resource.id}/bookings?from=2011-03-03T01:00:00&to=2011-03-03T02:00:00"
    assert_response_created
  end

  def test_assert_post_bookings_resource_with_conflict
    post "/resources/#{@resource.id}/bookings?from=2013-09-26T10:00:00Z&to=2013-11-26T11:00:01Z"
    assert_response_conflict
  end

  def test_all_methods
    get "/resources/#{@resource.id}/availability"
    assert_response_ok

    put "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_response_ok

    get "/resources/#{@resource.id}/bookings/#{@booking.id}"
    assert_response_ok

    delete "/resources/#{@resource.id}/bookings/#{@booking_delete.id}"
    assert_response_ok

  end

end
