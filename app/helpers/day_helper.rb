module DayHelper
  def today_abbrev
    today.gsub(/day/,"")
  end

  def today
    Date.today.strftime('%A')
  end
end