require 'test_helper'

class BookingTest < Minitest::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::Helpers

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @resource = Resource.create(name: 'aResource', description: 'aDescription')
  end

   def teardown
    DatabaseCleaner.clean
  end

  def test_empty_database
    assert_equal(0, Booking.all.size)
  end

  def test_load_data_database
    assert_equal(0, Booking.all.size)
    @booking = @resource.bookings.create(start: Date.today, end: (Date.today+1), status: 'pending')
    @booking = @resource.bookings.create(start: Date.today, end: (Date.today+1), status: 'pending')
    @booking = @resource.bookings.create(start: Date.today, end: (Date.today+1), status: 'pending')
    assert_equal(3, Booking.all.size)
  end

  def test_validate_presence
    assert(@resource.bookings.new(start: Date.today, end: (Date.today+1), status: 'pending').valid?)
    assert(@resource.bookings.new(start: Date.today, end: (Date.today+1)).valid?)
    refute(Booking.new().valid?)
    refute(Booking.new(resource_id: @resource.id ).valid?)
  end

  def test_validate_inclusion
    booking = Booking.new(resource_id: @resource.id, start: Date.today, end: (Date.today+1))
    booking.status = 'approved'
    assert(booking.valid?)
    #REFACTOR! negar este test y los siguientes y el estado rejacted y probar con status cancelado
  end

  def test_callback_set_pending_status
    booking = @resource.bookings.create(start: Date.today, end: (Date.today+1))
    assert_equal(booking.status, 'pending')
  end

end
