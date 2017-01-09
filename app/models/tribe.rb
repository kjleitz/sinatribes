class Tribe < ActiveRecord::Base

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

  belongs_to :user
  belongs_to :religion
  has_one :population
  has_many :messengers
  has_many :tribe_buildings
  has_many :buildings, through: :tribe_buildings
  has_many :resources

  validates_presence_of :user
  validates_presence_of :name
  validates_presence_of :religion

  after_create :initialize_tax_time
  after_create :make_active_tribe

  TAX_WAIT_PERIOD = 300
  LAND_PRICE = 100
  WARRIOR_PRICE = 50

  def initialize(args)
    super
    self.update(
      population: self.population || Population.create,
      religion: self.religion || Religion.all.sample
    )
  end

  def initialize_tax_time
    self.update(last_tax_collection: self.last_tax_collection || self.created_at)
  end

  def make_active_tribe
    self.user.switch_active_tribe_to(self)
  end

  def warriors
    self.population.warriors
  end

  def farmers
    self.population.farmers
  end

  def priests
    self.population.priests
  end

  def happiness
    self.population.happiness
  end

  def add_money(amt)
    self.update(money: self.money + amt)
  end

  def lose_money(amt)
    self.money >= amt ? self.update(money: self.money - amt) : false
  end

  def collect_taxes
    if (Time.now - self.last_tax_collection) > TAX_WAIT_PERIOD
      add_money(self.population.taxes)
      self.update(last_tax_collection: Time.now)
    end
  end

  def enlist_warriors(amt)
    if has_building?("barracks") && lose_money(WARRIOR_PRICE * amt)
      add_warriors(amt)
    end
  end

  def add_warriors(amt)
    self.population.update(warriors: self.warriors + amt)
  end

  def lose_warriors(amt)
    self.warriors >= amt ? self.population.update(warriors: self.warriors - amt) : false
  end

  def ordain_priest
    if has_building?("temple") && lose_resource("cloth")
      add_priests(1)
    end
  end

  def add_priests(amt)
    self.population.update(priests: self.priests + amt)
  end

  def buy_land(amt)
    # ternary w/ false because the alt is true (style dictates false, not nil)
     lose_money(amt * LAND_PRICE) ? add_land(amt) : false
  end

  def add_land(amt)
    self.update(land: self.land + amt)
  end

  def lose_land(amt)
    # ternary w/ false because the alt is true (style dictates false, not nil)
    self.land >= amt ? self.update(land: self.land - amt) : false
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
    if resource = self.resources.find_by(name: resource_name)
      resource.destroy
    end
  end

  def count_resource(resource_name)
    self.resources.where(name: resource_name).count
  end

  def list_resources
    self.resources.map { |resource| resource.name }.uniq
  end

  # # The following two methods assume tribes can only build one of each type
  # # of building. I think this functionality makes sense, to some extent.
  #
  # def build_building(building_name)
  #   if building = Building.find_by(name: building_name)
  #     if building.price <= self.money &&
  #        building.resource_amount <= count_resource(building.resource_name) &&
  #        !self.buildings.include?(building)
  #       lose_money(building.price)
  #       building.resource_amount.times { lose_resource(building.resource_name) }
  #       self.tribe_buildings.create(building: building)
  #     end
  #   end
  # end
  #
  # def add_building(building_name)
  #   if building = Building.find_by(name: building_name)
  #     self.tribe_buildings.find_or_create_by(building: building)
  #   end
  # end

  # The following three methods assume tribes can build more than one building
  # of a single type. The reason I went with this method of multiple-
  # same-object-association (That's not a term, Keegan. Yeah, I know, Keegan.)
  # instead of the model I have with resources (being that each resource is like
  # a commodity, e.g. there are a finite and 'real' number of pieces of iron,
  # they can be created, traded, or destroyed. Not just the references to them,
  # but the records/objects themselves) is that a resource just has a name,
  # and is a very simple record, whereas a building is meant to be more complex,
  # with a multi-variable cost, and extra attributes planned for the future. So,
  # I think it makes more sense to store multiple records of the association a
  # tribe has to the building type, rather than store multiple records of the
  # building type for every building the tribe builds. By storing multiple
  # identical records in the "join table"-esque tribe_buildings table, each
  # tribe_building has an id, and is itself only a three-column record of only
  # integers, which is a lot less data than storing a new building every time.
  # The other main difference is that a building is not meant to be transferred
  # between two tribes. It may be destroyed in raids, or maybe dismantled for
  # parts, but it's an immovable object that has a "type".
  # Although, one of the reasons I DISLIKE this way of doing things is that
  # when I want to count each building type in a tribe, I have to make two
  # database queries: one to get the building id from the name, and a second
  # to actually count the tribe_building records in tribe_buildings.
  # You also need to reload the tribe object if you want to access the tribe's
  # buildings after adding one, since it is manually adding records to the child
  # table. If you use the reload_object optional argument on #build_building or
  # #add_building, you can force a reload of the object afterward (but only if
  # the building was successfully added).

  def build_building(building_name)
    if building = Building.find_by(name: building_name)
      if building.price <= self.money &&
         building.resource_amount <= count_resource(building.resource_name)
        lose_money(building.price)
        building.resource_amount.times { lose_resource(building.resource_name) }
        self.tribe_buildings.create(building: building)
      end
    end
  end

  def add_building(building_name)
    if building = Building.find_by(name: building_name)
      self.tribe_buildings.create(building: building)
    end
  end

  def count_building(building_name)
    self.buildings.where(name: building_name).count
  end

  def has_building?(building_name)
    count_building(building_name) > 0
  end

  def use_building(building_name)
    resource_name = ""
    amt = count_building(building_name).times do
      resource = self.buildings.find_by(name: building_name).use
      collect_resource(resource)
      resource_name = resource.name
    end
    [amt, resource_name]
  end

  def strength
    str_val = self.warriors + self.happiness
    str_val.to_i
  end

  def defend
    def_val = strength * (1 + count_building("walls")) * (1 + count_building("barracks") * 0.5)
    def_val *= 10 if self.priests > (self.population.total * 0.5)
    def_val.to_i
  end

  def attack
    atk_val = strength * (1 + count_building("barracks") * 0.5) * (1 + count_building("town hall") * 0.5)
    atk_val.to_i
  end

end
