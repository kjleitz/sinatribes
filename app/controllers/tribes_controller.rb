class TribesController < ApplicationController

  get "/tribes" do
    @tribes = Tribe.all
    erb :"tribes/index"
  end

  get "/tribes/new" do
    @religions = Religion.all
    erb :"tribes/new"
  end

end
