class Resource < ActiveRecord::Base
  belongs_to :tribe
  belongs_to :gift

  DISCOVERABLES = [
    "iron",
    "wood",
    "food",
    "stone"
  ]

  def self.discover
    self.create(name: DISCOVERABLES.sample)
  end

end
