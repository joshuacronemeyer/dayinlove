class PagesController < ApplicationController
  def home
  end

  def auth
    # auth = request.env["omniauth.auth"]
    # user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth)
    # session[:user_id] = user.id
    # p auth
    p "HERE"
    redirect_to root_url, :notice => "Signed in!"
  end
end