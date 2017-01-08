class MessengersController < ApplicationController

  get "/messengers/new/:id" do |id|
    if destination = Tribe.find_by(id: id)
      if tribe = current_user.tribe
        @messenger = Messenger.create(tribe: tribe, destination: destination)
        erb :"messengers/new"
      else
        flash[:message] = "You need to set an <strong>active tribe</strong> before you can send a messenger to another tribe."
        redirect to("/")
      end
    else
      flash[:message] = "You can't send a messenger to a tribe that doesn't exist!"
      redirect to("/")
    end
  end

end
