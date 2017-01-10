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
      flash[:message] = "Something went wrong. Please try again!"
      redirect to("/tribes/new")
    end
  end

  get "/tribes/:slug" do |slug|
    if @tribe = Tribe.find_by_slug(slug)
      @current_user = current_user
      erb :"/tribes/show"
    else
      404
    end
  end

  patch "/tribes/:slug/activate", current_user_tribe: true do |slug|
    @tribe.make_active_tribe || flash[:message] = "Something went wrong. Please try again!"
    redirect to("/")
  end

  get "/tribes/:slug/manage", current_user_tribe: true do |slug|
    @buildings = Building.all
    @land_price = Tribe::LAND_PRICE
    @warrior_price = Tribe::WARRIOR_PRICE
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

  patch "/tribes/:slug/buildings", current_user_tribe: true do |slug|
    amt, resource_name = @tribe.use_building(params[:building_name])
    if !resource_name.empty?
      flash[:message] = "Obtained #{amt} #{resource_name}!"
    else
      building_time = Building::BUILDING_WAIT_PERIOD - (Time.now - @tribe.buildings.find_by(name: params[:building_name]).last_used)
      flash[:message] = "You need to wait #{building_time.to_i} seconds until you can use this building again."
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
    if @tribe.buy_land(amt)
      flash[:message] = "Successfully purchased #{amt} square mile#{"s" if amt > 1} of land!"
    else
      flash[:message] = "You cannot afford that amount of land."
    end
    redirect to("/tribes/#{slug}/manage")
  end

  patch "/tribes/:slug/warriors", current_user_tribe: true do |slug|
    amt = params[:amount].to_i
    if @tribe.enlist_warriors(amt)
      flash[:message] = "Successfully enlisted #{amt} warrior#{"s" if amt > 1}. Feelin' strong!"
    else
      flash[:message] = "You cannot afford that many warriors."
    end
    redirect to("/tribes/#{slug}/manage")
  end

  patch "/tribes/:slug/warriors", current_user_tribe: true do |slug|
    amt = params[:amount].to_i
    if @tribe.invite_farmers(amt)
      flash[:message] = "Successfully invited #{amt} farmer#{"s" if amt > 1}. They seem... nice."
    else
      flash[:message] = "You need one hut for every ten farmers. Who wants to tend livestock when you're squished together like... Ahem."
    end
    redirect to("/tribes/#{slug}/manage")
  end

  patch "/tribes/:slug/priests", current_user_tribe: true do |slug|
    if @tribe.ordain_priest
      flash[:message] = "Successfully ordained a priest. Nobody's holier than thou!"
    else
      flash[:message] = "Priests are men of the cloth... one cloth, specifically. Try again when you have some."
    end
    redirect to("/tribes/#{slug}/manage")
  end

  delete "/tribes/:slug/delete", current_user_tribe: true do |slug|
    if @tribe.destroy
      flash[:message] = "Successfully deleted \"#{@tribe.name}\"."
    else
      flash[:message] = "Something went wrong. Please try again!"
    end
    redirect to("/")
  end

  def not_your_tribe
    flash[:message] = "This is not your tribe. Why are you trying to do that?"
    redirect to("/tribes/#{params[:slug]}")
  end

  get("/tribes/:slug/*", current_user_tribe: false) { not_your_tribe }
  post("/tribes/:slug/*", current_user_tribe: false) { not_your_tribe }
  patch("/tribes/:slug/*", current_user_tribe: false) { not_your_tribe }
  delete("/tribes/:slug/*", current_user_tribe: false) { not_your_tribe }

end
