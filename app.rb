require 'bundler'
require 'sinatra'
require 'sinatra/activerecord'

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

before do
  content_type 'application/json'
end

get '/' do
  @url = request.url
  puts params
  jbuilder :url
end
