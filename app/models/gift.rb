class Gift < ActiveRecord::Base
  has_one :resource
  belongs_to :messenger

  def accepted?
    self.accepted
  end

  def accept
    receiver = self.messenger.destination
    receiver.add_money(self.money)
    receiver.add_warriors(self.warriors)
    receiver.collect_resource(self.resource)
    self.update(accepted: true)
  end

  def add_money(amt)
    self.update(money: amt) if self.messenger.tribe.pay(amt)
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
