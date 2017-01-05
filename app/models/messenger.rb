class Messenger < ActiveRecord::Base
  has_one :gift
  belongs_to :home, foreign_key: :home_id, class_name: 'Tribe'
  belongs_to :destination, foreign_key: :destination_id, class_name: 'Tribe'
end
