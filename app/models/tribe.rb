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
  has_many :resources

  validates_presence_of :user
  validates_presence_of :name
  validates_presence_of :religion

  def initialize(args)
    super
    self.update(
      population: self.population || Population.create,
      religion: self.religion || Religion.all.sample
    )
  end

  def add_money(amt)
    self.update(money: self.money + amt)
  end

  def lose_money(amt)
    self.money >= amt ? self.update(money: self.money - amt) : false
  end

  def add_warriors(amt)
    self.update(warriors: self.warriors + amt)
  end

  def lose_warriors(amt)
    self.warriors >= amt ? self.update(warriors: self.warriors - amt) : false
  end

  # For adding existing resources to self
  def collect_resource(resource)
    resource.update(tribe: self, gift: nil)
  end

  # For creating a new resource and adding it to self
  def add_resource(resource_name)
    self.resources.create(name: resource_name)
  end

  def lose_resource(resource_name)
    if resource = self.resources.find_by(name: resource)
      resource.destroy
    end
  end

  def count_resource(resource_name)
    self.resources.where(name: resource_name).count
  end

  def build_building(building_name)
    if building = Building.find_by(name: building_name)
      if building.price <= self.money && building.resource_amount <= count_resource(building.resource_name)
        lose_money(building.price)
        building.resource_amount.times { lose_resource(building.resource_name) }
        self.tribe_buildings.create(building: building)
      end
    end
  end

end
