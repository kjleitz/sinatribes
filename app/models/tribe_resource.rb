class TribeResource < ActiveRecord::Base
  belongs_to :tribe
  belongs_to :resource
end
