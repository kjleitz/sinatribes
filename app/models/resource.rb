class Resource < ActiveRecord::Base
  has_many :tribe_resources
  has_many :tribes, through: :tribe_resources
end
