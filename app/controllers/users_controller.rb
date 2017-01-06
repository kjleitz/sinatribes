class UsersController < ApplicationController

  get "/", logged_in: true do
    erb :"users/index"
  end

  get "/signup" do
    redirect to("/") if logged_in?
    erb :"users/signup"
  end

  post "/signup" do
    if !User.validate_username(params[:username])
      flash[:message] = "Usernames may only contain letters, numbers, and underscores, and be less than 80 characters in length."
    elsif !User.validate_email(params[:email])
      flash[:message] = "Please enter a valid email address."
    elsif User.find_by(username: params[:username])
      flash[:message] = "Sorry, the username '#{params[:username]}' is taken. Please try something else."
    elsif User.find_by(email: params[:email])
      flash[:message] = "There's already an account using this email address. Would you like to <a href=\"/login\">log in</a> instead?"
    elsif params[:password].empty?
      flash[:message] = "Password cannot be blank."
    elsif user = User.create(username: params[:username], email: params[:email], password: params[:password])
      flash[:message] = "Successfully signed up!"
      session[:user_id] = user.id
    else
      flash[:message] = "Something went wrong. Please try again."
    end

    redirect user ? to("/") : to("/signup")
  end

  get "/login" do
    redirect to("/") if logged_in?
    erb :"users/login"
  end

  post "/login" do

  end

  get "/logout" do
    session.clear
    redirect to("/")
  end

  get /\A\/.+/, logged_in: false do
    redirect to("/login")
  end

end
