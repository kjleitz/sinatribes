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
    @buildings = Building.all
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
      flash[:message] = "This is not your tribe to buy buildings for!"
    end
    redirect to("/tribes/#{slug}/manage")
  end

  patch "/tribes/:slug/taxes" do |slug|
    if @tribe = current_user.tribes.find_by_slug(slug)
      if @tribe.collect_taxes
        flash[:message] = "Successfully collected $#{@tribe.population.taxes}!"
      else
        tax_time = Tribe::TAX_WAIT_PERIOD - (Time.now - @tribe.last_tax_collection)
        flash[:message] = "You need to wait #{tax_time.to_i} seconds until you can collect taxes again."
      end
    else
      flash[:message] = "This is not your tribe to collect taxes for!"
    end
    redirect to("/tribes/#{slug}/manage")
  end

  patch "/tribes/:slug/activate" do |slug|
    if @tribe = current_user.tribes.find_by_slug(slug)
      @tribe.make_active_tribe || flash[:message] = "Something went wrong. Please try again!"
    else
      flash[:message] = "This is not your tribe to activate!"
    end
    redirect to("/")
  end

end
