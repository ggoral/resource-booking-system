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
  #corregir aca, testear que este entre 0 y 365. si es nill es 30
  halt 400 if Integer limit and (Integer limit) > 365
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

  @available_resource_id = params[:resource_id]
  @availables = @resource.periods_availables(date.to_time.utc.iso8601, limit.to_time.utc.iso8601)
  jbuilder :availables
end

post '/resources/:resource_id/bookings' do
  halt 400 unless params.include? 'from' and params.include? 'to'

  from, to = params['from'], params['to']
  
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
