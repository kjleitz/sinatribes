class Building < ActiveRecord::Base
  has_many :tribe_buildings
  has_many :tribes, through: :tribe_buildings

  ACTIONS = {
    "factory" => "manufacture",
    "farm" => "harvest",
    "mine" => "mine",
    "barracks" => "train"
  }

end
