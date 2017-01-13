class Building < ActiveRecord::Base
  has_many :tribe_buildings
  has_many :tribes, through: :tribe_buildings

  after_create :initialize_action
  after_create :initialize_used_time

  # Remember for later: This is global. It affects all users after one building use.
  BUILDING_WAIT_PERIOD = 30
  ACTIONS = {
    "factory" => "manufacture",
    "farm" => "harvest",
    "mine" => "mine",
    "lumber yard" => "chop"
  }

  def initialize_action
    self.update(action: ACTIONS[self.name]) if ACTIONS[self.name]
  end

  def initialize_used_time
    self.update(last_used: Time.now - BUILDING_WAIT_PERIOD) unless self.last_used
  end

  def waiting?
    Time.now - self.last_used < BUILDING_WAIT_PERIOD
  end

  def usable?
    !!self.action
  end

  def use
    if self.usable?
      self.update(last_used: Time.now)
      Resource.send(self.action)
    end
  end

end
