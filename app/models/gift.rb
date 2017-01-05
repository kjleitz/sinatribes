class Gift < ActiveRecord::Base
  belongs_to :resource
  belongs_to :messenger

  def accepted?
    self.accepted
  end

  def accept
    self.update(accepted: true)
  end

  def add_money(amt)
    self.update(money: amt) if self.messenger.tribe.pay(amt)
  end

  def add_warriors(amt)
    self.update(warriors: amt) if self.messenger.tribe.lose_warriors(amt)
  end

  def add_resource(amt, resource_name)
    if self.resource = self.messenger.tribe.resources.find_by(name: resource_name)
      self.resource_amount = amt
      self.save
    end
  end
end
