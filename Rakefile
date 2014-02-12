require 'rake/testtask'
require 'sinatra/activerecord/rake'
require './app'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end

desc 'Start a console'
task :console do
  ENV['RACK_ENV'] ||= 'development'
  %w(irb irb/completion).each { |r| require r }
  require_relative 'app'

  ARGV.clear
  IRB.start
end

task default: :test
