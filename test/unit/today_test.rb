require 'test_helper'

class TodayTest < ActiveSupport::TestCase
  def setup
    mock_app
    @now = Time.local(2012, 12, 11, 12, 0, 0)
    Timecop.freeze(@now) #Time is stuck on a tuesday. bummer.
  end

  test "tuesday we redirect to tues subdomain" do
    get 'http://dayinlove.com'
    assert_equal 301, last_response.status
    assert_equal "http://tues.dayinlove.com/", last_response.headers['Location']
  end


  test "tuesday we redirect to tues subdomain from another subdomain" do
    get 'http://mon.dayinlove.com'
    assert_equal 301, last_response.status
    assert_equal "http://tues.dayinlove.com/", last_response.headers['Location']
  end

  test "we leave localhost alone" do
    get 'http://localhost:3000'
    assert_equal 200, last_response.status
  end
end