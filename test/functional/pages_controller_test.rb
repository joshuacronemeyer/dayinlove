require 'test_helper'
require "#{Rails.root}/test/unit/user_test"
class PagesControllerTest < ActionController::TestCase
  test "successful authentication" do
    @request.env["omniauth.auth"] = UserTest::OMNIAUTH_AUTH
    get :auth, {"omniauth.auth" => false}
    assert_template 'auth'
    assert_equal 1234, assigns["user"].uid
  end

  test "failed authentication" do
    get :auth_failed
    assert_template 'home'
    assert_select ".alert-error", :text => "Your login attempt failed."
  end
end