ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
DatabaseCleaner.strategy = :truncation



class ActiveSupport::TestCase
  setup do 
  	DatabaseCleaner.clean
  end
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...

  # Add more helper methods to be used by all tests here...

end
  class ActionController::TestCase
  	include Devise::TestHelpers
  end