require 'bundler'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

# Configuration
ActiveRecord::Base.logger = nil
ActiveSupport.escape_html_entities_in_json = false


Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |ruby_file| require_relative ruby_file }
Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each { |ruby_file| require_relative ruby_file }


before do
  content_type 'application/json'
end

before '/resources/:resource_id*' do
  @resource = Resource.find_by(id: params[:resource_id])
  halt 404 unless @resource
end

before '/resources/:resource_id/bookings/:booking_id' do
  @booking = @resource.bookings.find_by(id: params[:booking_id])
  halt 404 unless @booking
end

# Remove this method before release
get '/' do
  @url = request.url
  jbuilder :url
end

get '/resources/:resource_id' do
  @resource = Resource.find_by(id: params[:resource_id])
  jbuilder :resource
end

get '/resources' do
  @resources = Resource.all
  jbuilder :resources
end

get '/resources/:resource_id/bookings' do
  date = params['date'] ? params['date'].to_date : Date.today + 1
  limit = params['limit'] ? params['limit'] : 30 
  status = params['status'] ? params['status'] : 'aproved' 
  puts params, date, limit, status
  @bookings = @resource.bookings
  jbuilder :bookings
end

get '/resources/:resource_id/availability' do
end

post '/resources/:resource_id/bookings' do
#  status 201
end

delete '/resources/:resource_id/bookings/:booking_id' do
end

put '/resources/:resource_id/bookings/:booking_id' do
end

get '/resources/:resource_id/bookings/:booking_id' do
  @booking = @resource.bookings.find_by(id: params[:booking_id])
  jbuilder :booking
end

get '/load' do
  #Load development database to test
  ActiveRecord::Base.connection.execute('DELETE FROM SQLITE_SEQUENCE WHERE name="resources";') 
  ActiveRecord::Base.connection.execute('DELETE FROM SQLITE_SEQUENCE WHERE name="bookings";')
  Resource.destroy_all
  Booking.destroy_all
  
  resource = Resource.create( 
    name: 'Computadora', 
    description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
  
  booking = resource.bookings.create(
    start: Time.now.utc.iso8601.to_date, 
    end: (Time.now.utc.iso8601.to_date+1), 
    status: 'aproved', 
    user: 'someuser@gmail.com')
  
  booking = resource.bookings.create(
    start: Time.now.utc.iso8601.to_date,
    end: (Time.now.utc.iso8601.to_date+1), 
    status: 'aproved', 
    user: 'otheruser@gmail.com')

  resource = Resource.create(
      name: "Monitor",
      description: "Monitor de 24 pulgadas SAMSUNG")
  
  resource = Resource.create(
      name: "Monitor",
      description: "Monitor de 24 pulgadas SAMSUNG")
end