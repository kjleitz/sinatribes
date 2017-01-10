class Gift < ActiveRecord::Base
  has_one :resource
  belongs_to :messenger

  def accepted?
    self.accepted
  end

  def reclaimed?
    self.reclaimed
  end

  def claimed?
    accepted? || reclaimed?
  end

  def accept(reclaim: false)
    unless claimed?
      receiver = reclaim ? self.messenger.tribe : self.messenger.destination
      receiver.add_money(self.money)
      receiver.add_warriors(self.warriors)
      receiver.collect_resource(self.resource) if self.resource
      reclaim ? self.update(reclaimed: true) : self.update(accepted: true)
    end
  end

  def add_money(amt)
    self.update(money: amt) if self.messenger.tribe.lose_money(amt)
  end

  def add_warriors(amt)
    self.update(warriors: amt) if self.messenger.tribe.lose_warriors(amt)
  end

  def attach_resource(resource_name)
    if resource = self.messenger.tribe.resources.find_by(name: resource_name)
      resource.update(tribe: nil, gift: self)
    end
  end
end
