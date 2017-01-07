class TribesController < ApplicationController

  get "/tribes/new" do
    @religions = Religion.all
    erb :"tribes/new"
  end

  get "/tribes" do
    @tribes = Tribe.all
    erb :"tribes/index"
  end

  post "/tribes" do
    params[:tribe][:user] = current_user
    if tribe = Tribe.create(params[:tribe])
      flash[:message] = "Tribe created successfully!"
      redirect to("/tribes/#{tribe.slug}/manage")
    else
      flash[:message] = "Something went wrong. Please try again."
      redirect to("/tribes/new")
    end
  end

  get "/tribes/:slug/manage" do |slug|
    if @tribe = current_user.tribes.find_by_slug(slug)
      erb :"tribes/manage"
    else
      flash[:message] = "This is not your tribe to manage!"
      redirect to("/tribes/#{slug}")
    end
  end

  post "/tribes/:slug/buildings" do |slug|
    if @tribe = current_user.tribes.find_by_slug(slug)
      if @tribe.build_building(params[:building_name])
        flash[:message] = "#{params[:building_name].capitalize} successfully built!"
      else
        building = Building.find_by(name: params[:building_name])
        flash[:message] = "You need $#{building.price} and #{building.resource_amount} #{building.resource_name} to build that building."
      end
    else
      flash[:message] = "Something went wrong. Please try again."
    end
    redirect to("/tribes/#{slug}/manage")
  end

end
