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
  halt 400 unless date.is_a? Date
  
  limit = params['limit'] ? params['limit'] : 30 
  halt 400 if limit.to_i > 365
  limit = date + limit.to_i.abs

  status = params['status'] ? params['status'] : 'approved'
  halt 400 unless ['approved','pending','all'].include? status
  status = nil if status == 'all'
  
  @bookings = @resource.book(date,limit,status)
  jbuilder :bookings
end

get '/resources/:resource_id/availability' do
  date = params['date'] ? params['date'].to_date : Date.today + 1
  halt 400 unless date.is_a? Date

  limit = params['limit'] ? params['limit'].to_i.abs : 30 
  halt 400 if limit > 365
  limit = date + limit

  @availables = @resource.book(date, limit, 'approved')
  jbuilder :availables
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
    start: "2013-10-26T10:00:00Z".to_time.utc.iso8601, 
    end: ("2013-10-26T11:00:00Z".to_time.utc.iso8601), 
    status: 'approved', 
    user: 'someuser@gmail.com')
  
  booking.update(status: 'approved')
  booking = resource.bookings.create(
    start: "2013-10-26T11:00:00Z".to_time.utc.iso8601,
    end: ("2013-10-26T12:30:00Z".to_time.utc.iso8601), 
    status: 'approved', 
    user: 'otheruser@gmail.com')

  resource = Resource.create(
      name: "Monitor",
      description: "Monitor de 24 pulgadas SAMSUNG")
  
  resource = Resource.create(
      name: "Sala de reuniones",
      description: "Sala de reuniones con máquinas y proyector")
end