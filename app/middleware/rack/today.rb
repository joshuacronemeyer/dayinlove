require 'rack'
require 'rack/request'

module Rack
  class Today
    include DayHelper

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      return redirect_to_today(env) if need_new_subdomain?(env)
      [status, headers, body]
    end

    private

    def subdomain(env)
      match = env["SERVER_NAME"].match(/^(^.*)\.dayinlove.com/)
      match[1] if match
    end

    def redirect_to_today(env)
      req = Request.new(env)
      url = URI(req.url)
      url.host = "#{today_abbrev.downcase}.dayinlove.com"
      headers = {'Content-Type' => 'text/html', 'Location' => url.to_s}
      [301, headers, []]
    end

    def need_new_subdomain?(env)
      return false if env["SERVER_NAME"] =~ /localhost/i
      subdomain(env) != today_abbrev.downcase
    end
  end
end