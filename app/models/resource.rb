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

  CHOPPABLES = [
    "wood"
  ]

  def self.discover
    self.create(name: DISCOVERABLES.sample)
  end

  def self.harvest
    self.create(name: HARVESTABLES.sample)
  end

  def self.mine
    self.create(name: MINEABLES.sample)
  end

  def self.manufacture
    self.create(name: MANUFACTURABLES.sample)
  end

  def self.chop
    self.create(name: CHOPPABLES.sample)
  end

end
