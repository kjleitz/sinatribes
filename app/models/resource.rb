class Resource < ActiveRecord::Base
  belongs_to :tribe
  belongs_to :gift

  DISCOVERABLES = [
    "iron",
    "wood",
    "food",
    "stone"
  ]

  HARVESTABLES = [
    "food"
  ]

  MANUFACTURABLES = [
    "cloth"
  ]

  MINEABLES = [
    "iron",
    "stone",
    "coal"
  ]

  def self.discover
    self.create(name: DISCOVERABLES.sample)
  end

end
