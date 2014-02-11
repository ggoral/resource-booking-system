require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

before do
  content_type 'application/json'
end

get '/' do
  @url = request.url
  jbuilder :url
end
