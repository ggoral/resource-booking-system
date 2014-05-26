require 'test_helper'

class GetResourcesResourceIdAvailabilityTest < Minitest::Unit::TestCase
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

  def test_get_resource_availability
    assert_get_resource 'availability'
  end

  def test_non_existent_resource
    assert_non_existent_resource 'availability'
  end

  def test_get_resources_with_date_limit_status
    assert_get_resources_with_date_limit_status('availability', '2013-10-26','365', 'pending')
  end

  def test_get_resources_with_date_limit_status
    refute_get_resources_with_date_limit_status('availability', '2013-10-26','366', 'pending')
  end

  def test_get_resources_with_date
    assert_get_resources_with_date('availability','2013-10-26')
  end
    
  def test_get_resources_with_limit
    assert_get_resources_with_limit('availability','1')
  end

  def test_get_resources_with_status
    assert_get_resources_with_status('availability','pending')
  end

  def test_json_availability
    server_response = get "/resources/#{Resource.first.id}/availability?date=2013-10-20&limit=30"
    assert_equal 200, last_response.status
    
    json = JSON.parse server_response.body
    assert available = json
    
    available = Resource.first.periods_availables(
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
end
