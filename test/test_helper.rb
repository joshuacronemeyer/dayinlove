ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include Rack::Test::Methods
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  def app; Rack::Lint.new(@app); end
  def mock_app
  main_app = lambda { |env|
    request = Rack::Request.new(env)
    headers = {'Content-Type' => "text/html"}
    [200, headers, ['Hello world!']]
  }

  builder = Rack::Builder.new
  builder.use Rack::Today
  builder.run main_app
  @app = builder.to_app
  end
  # Add more helper methods to be used by all tests here...
end
