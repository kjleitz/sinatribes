class Population < ActiveRecord::Base
  belongs_to :tribe

  def total
    self.warriors + self.farmers + self.priests
  end

  def happiness
    happy_val = 0
    happy_val += self.tribe.buildings.count
    happy_val += self.priests
    happy_val += (self.warriors / 2)
    happy_val -= self.farmers if (total / self.tribe.land) > 50
  end

end
