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

  def add_money(amt)
    self.update(money: self.money + amt)
  end

  def lose_money(amt)
    self.money >= amt ? self.update(money: self.money - amt) : false
  end

  def lose_warriors(amt)
    self.warriors >= amt ? self.update(warriors: self.warriors - amt) : false
  end
end
