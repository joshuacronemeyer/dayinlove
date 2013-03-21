class User < ActiveRecord::Base
  has_many :love_requests
  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
      user.token = auth["credentials"]["token"]
      user.secret = auth["credentials"]["secret"]
    end
  end

  def tweet(message)
    Twitter.configure do |config|
      config.consumer_key = "km3qqeLxsDAPglsE5n4zRg"
      config.consumer_secret = "2ZjZAJvnXKSZPzDKFVbBZ98yAtP9kWDhP30w7YYzw4"
      config.oauth_token = self.token
      config.oauth_token_secret = self.secret
    end

    client = Twitter::Client.new
    client.update(message)
  end
end
