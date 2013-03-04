source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'thin'
gem 'jquery-rails'
gem 'omniauth-twitter'
gem 'rmagick'
gem 'aws-sdk'
gem 'rest-open-uri'
gem 'twitter'
gem 'delayed_job_active_record'

gem 'sass-rails',   '~> 3.2.3' #moved out of assets becuase we failover to runtime compilation because DJ connects to DB early.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'sqlite3'
  gem 'timecop'
end

group :production do
  gem 'pg'
end