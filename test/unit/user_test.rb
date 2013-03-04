require 'test_helper'

class UserTest < ActiveSupport::TestCase
  OMNIAUTH_AUTH = {"uid"=> 1234, "info"=> {"nickname" => "cuberick", "name" => "josh"}, "credentials" => {"token" => "1", "secret" => "1"}}
  test "create from omniauth success response" do
    user = User.create_with_omniauth(OMNIAUTH_AUTH)
    assert_equal "cuberick", user.nickname
  end
end
