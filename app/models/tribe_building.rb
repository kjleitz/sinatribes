class TribeBuilding < ActiveRecord::Base
  belongs_to :tribe
  belongs_to :building
end
