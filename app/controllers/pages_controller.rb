class PagesController < ApplicationController
  def home
    #hi
  end

  def auth
    auth = request.env["omniauth.auth"]
    @user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = @user.id
  end

  def auth_failed
    @auth_failed = true
    render :home
  end
end