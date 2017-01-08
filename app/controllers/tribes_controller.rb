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

  patch "/tribes/:slug/activate", current_user_tribe: true do |slug|
    @tribe.make_active_tribe || flash[:message] = "Something went wrong. Please try again!"
    redirect to("/")
  end

  get "/tribes/:slug/manage", current_user_tribe: true do |slug|
    @buildings = Building.all
    @land_price = Tribe::LAND_PRICE
    erb :"tribes/manage"
  end

  post "/tribes/:slug/buildings", current_user_tribe: true do |slug|
    if @tribe.build_building(params[:building_name])
      flash[:message] = "#{params[:building_name].capitalize} successfully built!"
    else
      building = Building.find_by(name: params[:building_name])
      flash[:message] = "You need $#{building.price} and #{building.resource_amount} #{building.resource_name} to build that building."
    end
    redirect to("/tribes/#{slug}/manage")
  end

  patch "/tribes/:slug/taxes", current_user_tribe: true do |slug|
    if @tribe.collect_taxes
      flash[:message] = "Successfully collected $#{@tribe.population.taxes}!"
    else
      tax_time = Tribe::TAX_WAIT_PERIOD - (Time.now - @tribe.last_tax_collection)
      flash[:message] = "You need to wait #{tax_time.to_i} seconds until you can collect taxes again."
    end
    redirect to("/tribes/#{slug}/manage")
  end

  patch "/tribes/:slug/land", current_user_tribe: true do |slug|
    amt = params[:amount].to_i
    if @tribe.buy_land(amt.to_i)
      flash[:message] = "Successfully purchased #{amt} square mile#{"s" if amt > 1} of land!"
    else
      flash[:message] = "You cannot afford that amount of land."
    end
    redirect to("/tribes/#{slug}/manage")
  end

end
