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
    assert(Resource.new(name: "resource", description: "description").valid?)
    assert(Resource.new(name: "resource").valid?)
    refute(Resource.new().valid?)
    refute(Resource.new(description: "description").valid?)
  end

  def test_available_method
    assert(Resource.new(name: "resource", description: "description").valid?)
    assert(Resource.new(name: "resource").valid?)
    refute(Resource.new().valid?)
    refute(Resource.new(description: "description").valid?)
  end


end