class Tribe < ActiveRecord::Base
  belongs_to :user
  belongs_to :religion
  has_one :population
  has_one :warriors, through: :population
  has_one :farmers, through: :population
  has_one :priests, through: :population
  has_many :messengers
  has_many :tribe_buildings
  has_many :buildings, through: :tribe_buildings
  has_many :tribe_resources
  has_many :resources, through: :tribe_resources
end
