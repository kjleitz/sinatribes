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

  def purchase_amt_and_manage(success, failure, purch_method, amt=nil)
    if amt && amt < 0
      flash[:message] = "Not to be negative, but... no negatives."
    elsif amt && amt == 0
      flash[:message] = "Good job. You got... nothing for your troubles. That was a sarcastic 'good job', if you couldn't tell."
    else
      purchased = amt ? @tribe.send(purch_method, amt.to_i) : @tribe.send(purch_method)
      flash[:message] = purchased ? success : failure
    end
    redirect to("/tribes/#{params[:slug]}/manage")
  end

  patch "/tribes/:slug/land", current_user_tribe: true do |slug|
    amt = params[:amount].to_i
    success = "Successfully purchased #{amt} square mile#{"s" if amt > 1} of land!"
    failure = "You cannot afford that amount of land."
    purchase_amt_and_manage(success, failure, :buy_land, amt)
  end

  patch "/tribes/:slug/warriors", current_user_tribe: true do |slug|
    amt = params[:amount].to_i
    success = "Successfully enlisted #{amt} warrior#{"s" if amt > 1}. Feelin' strong!"
    failure = "You cannot afford that many warriors."
    purchase_amt_and_manage(success, failure, :enlist_warriors, amt)
  end

  patch "/tribes/:slug/farmers", current_user_tribe: true do |slug|
    amt = params[:amount].to_i
    success = "Successfully invited #{amt} farmer#{"s" if amt > 1}. They seem... nice."
    failure = "You need one hut for every ten farmers. Who wants to tend livestock when you're squished together like... Ahem."
    purchase_amt_and_manage(success, failure, :invite_farmers, amt)
  end

  patch "/tribes/:slug/priests", current_user_tribe: true do |slug|
    success = "Successfully ordained a priest. Nobody's holier than thou!"
    failure = "Priests are men of the cloth... one cloth, specifically. Try again when you have some."
    purchase_amt_and_manage(success, failure, :ordain_priest)
  end

  patch "/tribes/:slug/raid", current_user_tribe: false do |slug|
    defender = Tribe.find_by_slug(slug)
    if attacker = current_user.tribe
      case attacker.raid(defender)
      when :win
        flash[:message] = "You successfully raided #{defender.name}! Check your war messages (on the tribe management page) for more details."
      when :draw
        flash[:message] = "#{defender.name} was a SERIOUSLY tough opponent. You bounced off each other like a couple of flirts. Check your war messages (on the tribe management page) for more details."
      when :loss
        flash[:message] = "You win some, you lose some. But this time, you really lost some. Them's the breaks. You should look up the literal meaning of the word \"decimated\", and then check your war messages (on the tribe management page) for more details."
      end
      redirect to("/tribes/#{slug}")
    else
      flash[:message] = "You need to set an <strong>active tribe</strong> before you can raid another tribe."
      redirect to("/")
    end
  end

  delete "/tribes/:slug/delete", current_user_tribe: true do |slug|
    if @tribe.destroy
      flash[:message] = "Successfully deleted \"#{@tribe.name}\"."
    else
      flash[:message] = "Something went wrong. Please try again!"
    end
    redirect to("/")
  end

  delete "/tribes/:slug/war_messages", current_user_tribe: true do |slug|
    @tribe.war_messages.clear
    @tribe.save
    flash[:message] = "We've always been at war with Eastasia."
    redirect to("/tribes/#{slug}/manage")
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
