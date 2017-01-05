class Population < ActiveRecord::Base
  belongs_to :tribe

  def total
    self.warriors + self.farmers + self.priests
  end
end
