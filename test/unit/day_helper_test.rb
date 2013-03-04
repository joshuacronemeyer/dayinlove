require 'test_helper'
class DayHelperTest < ActiveSupport::TestCase
  include DayHelper
  test "knows the day of the week on monday" do
    @now = Time.local(2012, 12, 10, 12, 0, 0)
    Timecop.freeze(@now)
    assert_equal "Monday", today
    assert_equal "Mon", today_abbrev
  end
end