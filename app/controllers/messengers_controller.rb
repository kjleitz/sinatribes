class MessengersController < ApplicationController

  get "tribes/:tribe_slug/messengers/new" do |id|
    if @tribe = Tribe.find_by_slug(params[:tribe_slug])
      if @users_tribe = current_user.tribe
        if @users_tribe != @tribe
          erb :"messengers/new"
        else
          flash[:message] = "This is your tribe. You can't send a messenger to your own tribe, silly!"
          redirect to("/tribes/#{@tribe.slug}")
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

  post "tribes/:tribe_slug/messengers" do
    if destination = Tribe.find_by_slug(params[:tribe_slug])
      if current_user.tribe == destination
        flash[:message] = "No loopholes! Sending a message to your own tribe is weird and unnatural and I don't like it, so stop trying. Oh god, PLEASE stop trying!"
        redirect to("/tribes/#{destination.slug}")
      else
        messenger = current_user.tribe.messengers.create(
          message: params[:message],
          destination: destination
        )
        messenger.gift.add_money(params[:gift][:money].to_i)
        messenger.gift.add_warriors(params[:gift][:warriors].to_i)
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

  get "/messengers/:slug", current_user_tribe: true do
    @received_messengers = Messenger.where(destination_id: @tribe.id)
    @sent_messengers = @tribe.messengers
    erb :"messengers/index"
  end

  patch "/messengers/:slug/reject", current_user_tribe: true do
    if messenger = Messenger.find_by(id: params[:reject_messenger])
      if messenger.reject
        flash[:message] = "Messenger rejected!"
      else
        flash[:message] = "Something went wrong. Did you already reject that messenger? Aren't you kinda beating a dead horse? Give the guy a break. Sheesh."
      end
    end

    redirect to("/messengers/#{@tribe.slug}")
  end



  if gift = Gift.find_by(id: params[:accept_gift])
    if gift.accept
      flash[:message] = "Gift accepted!"
    else
      flash[:message] = "Something went wrong. Did you already accept that gift? Are you getting GREEDY?"
    end
  end

  if gift = Gift.find_by(id: params[:reclaim_gift])
    if gift.accept(reclaim: true)
      flash[:message] = "Gift reclaimed!"
    else
      flash[:message] = "Something went wrong. Did you already reclaim that gift? Are you getting GREEDY?"
    end
  end


end
