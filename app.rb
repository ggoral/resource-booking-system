require 'bundler'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

# Config
ActiveRecord::Base.logger = nil
ActiveSupport.escape_html_entities_in_json = false
I18n.enforce_available_locales = false


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

get '/resources/:resource_id' do
  jbuilder :resource
end

put '/resources/:resource_id' do
  validate_permited_params(params, ['name','description'])

  name = params['name']
  description = params['description']

  if (name or description) then
    @resource.update(name: name) if name
    @resource.update(description: description) if description
  end

  jbuilder :resource
end

get '/resources' do
  @resources = Resource.all
  jbuilder :resources
end

post '/resources' do
  name = validate_presence_param params['name']
  description = params['description']

  @resource = Resource.create( name: name, description: description)

  jbuilder :resource
end

get '/resources/:resource_id/availability' do
  date = validate_param_date params['date']
  limit = validate_param_limit params['limit']
    
  limit = date + limit.to_i.abs

  @available_resource_id = params[:resource_id]
  @availables = @resource.periods_availables(date.to_time.utc.iso8601, limit.to_time.utc.iso8601)
  jbuilder :availables
end

get '/resources/:resource_id/bookings' do
  date = validate_param_date params['date']
  limit = validate_param_limit params['limit']
  status = validate_param_status params['status']

  limit = date + limit.to_i.abs
  
  @bookings = @resource.book(date,limit,status)
  jbuilder :bookings
end

post '/resources/:resource_id/bookings' do
  from = validate_presence_param params['from']
  to = validate_presence_param params['to']
  
  if @resource.available?(from, to)
    @booking = @resource.bookings.create(start: from, end: to)
    status 201
    jbuilder :booking 
  else
    halt 409
  end
end

delete '/resources/:resource_id/bookings/:booking_id' do
  @booking.destroy ? status(200) : halt(409)
end

put '/resources/:resource_id/bookings/:booking_id' do
  halt 409 if @booking.status == 'approved'

  @booking.update(status: 'approved')
  jbuilder :booking
end

get '/resources/:resource_id/bookings/:booking_id' do
  @booking = @resource.bookings.find_by(id: params[:booking_id])
  jbuilder :booking
end
