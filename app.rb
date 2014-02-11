require 'bundler'
require 'sinatra'
require 'sinatra/activerecord'

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |ruby_file| require_relative ruby_file }

before do
  content_type 'application/json'
end

get '/' do
  @url = request.url
  puts params
  jbuilder :url
end

before '/resources/:resource_id*' do
#  @resource = Resource.find_by(id: params[:resource_id])
#  halt 404 unless @resource
end

before '/resources/:resource_id/bookings/:booking_id' do
#  @booking = @resource.bookings.find_by(id: params[:booking_id])
#  halt 404 unless @booking
end

get '/resources/:resource_id' do
#  @resource = Resource.find_by(id: params[:resource_id])
#  jbuilder :resource
end

get '/resources' do
#  @resources = Resource.all
#  jbuilder :resources
end

get '/resources/:resource_id/bookings' do
#  @bookings = @resource.bookings
#  jbuilder :bookings
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
#  @booking = @resource.bookings.find_by(id: params[:booking_id])
#  jbuilder :booking
end
