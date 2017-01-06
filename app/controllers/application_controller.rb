class ApplicationController < Sinatra::Base

  include Helper

  configure do
    set :public_folder, "public"
    set :views, "app/views"
    enable :sessions
    set :session_secret, "after all these implements and texts designed by intellects"
    use Rack::Flash
  end
end
