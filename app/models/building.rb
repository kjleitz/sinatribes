class Building < ActiveRecord::Base
  belongs_to :resource
  has_many :tribe_buildings
  has_many :tribes, through: :tribe_buildings
end
