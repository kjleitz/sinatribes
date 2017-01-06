class UsersController < ApplicationController

  get "/", logged_in: true do
    erb :"users/index"
  end

  get "/signup" do
    redirect to("/user/#{current_user.username}") if logged_in?
    erb :"users/signup"
  end

  post "/signup" do

  end

  get "/login" do
    redirect to("/user/#{current_user.username}") if logged_in?
    erb :"users/login"
  end

  post "/login" do

  end

  get /\A\/.+/, logged_in: false do
    redirect to("/login")
  end

end
