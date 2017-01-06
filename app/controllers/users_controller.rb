class UsersController < ApplicationController

  configure do
    set :views, "app/views/users"
    erb :layout, :"../layout"
  end

  get "/signup" do
    erb :signup
  end

  get "/login" do
    erb :login
  end

  get /\A\/.+/, logged_in: false do
    redirect to("/login")
  end

end
