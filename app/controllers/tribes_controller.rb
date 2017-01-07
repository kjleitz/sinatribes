class TribesController < Sinatra::Base

  get "/tribes" do
    @tribes = Tribe.all
    erb :"tribes/index"
  end

  get "/tribes/new" do
    erb :"tribes/new"
  end

end
