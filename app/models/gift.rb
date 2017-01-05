class Gift < ActiveRecord::Base
  belongs_to :resource
  belongs_to :messenger

  def accepted?
    self.accepted
  end

  def accept
    self.update(accepted: true)
  end
end
