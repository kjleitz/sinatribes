class Building < ActiveRecord::Base
  has_many :tribe_buildings
  has_many :tribes, through: :tribe_buildings

  after_create :initialize_action

  ACTIONS = {
    "factory" => "manufacture",
    "farm" => "harvest",
    "mine" => "mine"
  }

  def initialize_action
    self.update(action: ACTIONS[self.name]) if ACTIONS[self.name]
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
