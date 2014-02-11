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
