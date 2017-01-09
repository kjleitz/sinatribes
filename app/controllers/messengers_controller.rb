class MessengersController < ApplicationController

  get "/messengers/new/:id" do |id|
    if @destination = Tribe.find_by(id: id)
      if @tribe = current_user.tribe
        if @tribe != @destination
          erb :"messengers/new"
        else
          flash[:message] = "This is your tribe. You can't send a messenger to your own tribe, silly!"
          redirect to("/tribes/#{tribe.slug}")
        end
      else
        flash[:message] = "You need to set an <strong>active tribe</strong> before you can send a messenger to another tribe."
        redirect to("/")
      end
    else
      flash[:message] = "You can't send a messenger to a tribe that doesn't exist!"
      redirect to("/")
    end
  end

  post "/messengers" do
    if destination = Tribe.find_by(id: params[:destination_id])
      if current_user.tribe == destination
        flash[:message] = "No loopholes! Sending a message to your own tribe is weird and unnatural and I don't like it, so stop trying. Oh god, PLEASE stop trying!"
        redirect to("/tribes/#{destination.slug}")
      else
        messenger = Messenger.create(
          message: params[:message],
          tribe: current_user.tribe,
          destination: destination,
          gift: Gift.create(params[:gift])
        )
        messenger.gift.attach_resource(params[:resource_name])
        if messenger && messenger.gift
          flash[:message] = "Successfully sent the messenger!"
          redirect to("/messengers/#{current_user.tribe.slug}")
        else
          flash[:message] = "Something went wrong. Please try again!"
          redirect to("/messengers/new/#{params[:destination_id]}")
        end
      end
    else
      flash[:message] = "You can't send a messenger to a tribe that doesn't exist!"
      redirect to("/")
    end
  end

  get "/messengers/:slug", current_user_tribe: true do |slug|
    erb :"messengers/index"
  end

end
