require 'test_helper'

class ResourceTest < Minitest::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::Helpers

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end


  def test_empty_database
    assert_equal(0, Resource.all.size)
  end

  def test_load_data_database
    assert_equal(0, Resource.all.size)
    @resource = Resource.create(name: "resource1", description: "description1")
    @resource = Resource.create(name: "resource2", description: "description2")
    @resource = Resource.create(name: "resource3", description: "description3")
    assert_equal(3, Resource.all.size)
  end

  def test_accessors
    @resource = Resource.new(name: "aName", description: "aDescription")
    assert_equal("aName", @resource.name)
    assert_equal("aDescription", @resource.description)
  end

  def test_validate_name_presence
    assert(Resource.new(name: "resource", description: "description").valid?)
    assert(Resource.new(name: "resource").valid?)
    refute(Resource.new().valid?)
    refute(Resource.new(description: "description").valid?)
  end

  def test_book_method
    resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
    booking = resource.bookings.create(start: ("2013-03-03T00:00:00Z".to_time.utc.iso8601) , end: ("2013-03-03T23:59:59Z".to_time.utc.iso8601), status: 'pending')
    
    
    assert_equal(1, resource.book("2013-03-02T00:00:00Z".to_time.utc.iso8601, "2013-03-04T23:59:59Z".to_time.utc.iso8601).size)
    refute_equal(2, resource.book("2013-03-02T00:00:00Z".to_time.utc.iso8601, "2013-03-04T23:59:59Z".to_time.utc.iso8601).size)
  end

  def test_available_method
    resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
    booking = resource.bookings.create(start: ("2013-03-03T00:00:00Z".to_time.utc.iso8601) , end: ("2013-03-03T23:59:59Z".to_time.utc.iso8601), status: 'pending')
    
    refute(resource.available?("2013-03-02T00:00:00Z".to_time.utc.iso8601, "2013-03-04T23:59:59Z".to_time.utc.iso8601))
    booking.update(status: 'approved')
    assert(resource.available?("2013-03-02T00:00:00Z".to_time.utc.iso8601, "2013-03-04T23:59:59Z".to_time.utc.iso8601))
  end

  def test_approveds_method
    resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
    booking = resource.bookings.create(start: ("2013-03-03T00:00:00Z".to_time.utc.iso8601) , end: ("2013-03-03T23:59:59Z".to_time.utc.iso8601), status: 'pending')
    
    
    assert_equal(0,resource.approveds("2013-03-02T00:00:00Z".to_time.utc.iso8601, "2013-03-04T23:59:59Z".to_time.utc.iso8601).size)
    booking.update(status: 'approved')
    assert_equal(2,resource.approveds("2013-03-02T00:00:00Z".to_time.utc.iso8601, "2013-03-04T23:59:59Z".to_time.utc.iso8601).size)
  end
  
  def test_periods_availables_method
    resource = Resource.create( name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
    booking = resource.bookings.create(start: ("2013-03-03T00:00:00Z".to_time.utc.iso8601) , end: ("2013-03-03T23:59:59Z".to_time.utc.iso8601), status: 'pending')
    
    assert_equal(1,resource.periods_availables("2013-03-02T00:00:00Z".to_time.utc.iso8601, "2013-03-04T23:59:59Z".to_time.utc.iso8601).size)
    booking.update(status: 'approved')
    assert_equal(2,resource.periods_availables("2013-03-02T00:00:00Z".to_time.utc.iso8601, "2013-03-04T23:59:59Z".to_time.utc.iso8601).size)
  end

end