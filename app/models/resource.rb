class Resource < ActiveRecord::Base
  belongs_to :tribe
  belongs_to :gift
end
