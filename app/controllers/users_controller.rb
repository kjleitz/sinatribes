class UsersController < ApplicationController

  get "/", logged_in: true do
    @user = current_user
    erb :"users/index"
  end

  get "/signup" do
    redirect to("/") if logged_in?
    erb :"users/signup"
  end

  post "/signup" do
    user = User.new(params)
    if user.save
      flash[:message] = "Successfully signed up!"
      session[:user_id] = user.id
      redirect to '/'
    else
      flash[:message] = user.errors.full_messages
      redirect to '/signup'
    end
  end

  get "/login" do
    redirect to("/") if logged_in?
    erb :"users/login"
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:message] = "Logged in successfully!"
      redirect to("/")
    else
      flash[:message] = "Incorrect username and/or password. Please try again."
      redirect to("/login")
    end
  end

  get "/logout" do
    session.clear
    redirect to("/")
  end

  get /\A\/.+/, logged_in: false do
    redirect to("/login")
  end

  get "/users/:username" do |username|
    @user = User.find_by(username: username)
    erb :"users/show"
  end

end
