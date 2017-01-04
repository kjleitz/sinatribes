class Resource < ActiveRecord::Base
  has_many :tribe_resources
  has_many :resources, through: :tribe_resources
end
