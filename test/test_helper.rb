ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app', __FILE__
I18n.enforce_available_locales = false