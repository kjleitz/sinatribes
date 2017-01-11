class ApplicationController < Sinatra::Base

  include Helper

  configure do
    set :public_folder, "public"
    set :views, "app/views"
    enable :sessions
    set :session_secret, ENV["SECRET"]
    use Rack::Flash
    set(:logged_in) { |bool| condition { logged_in? == bool } }
    set(:current_user_tribe) do |bool|
      condition do
        !!(@tribe = current_user.tribes.find_by_slug(params[:slug])) == bool
      end
    end
  end

  get "/", logged_in: false do
    erb :index
  end

end
