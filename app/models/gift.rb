class Gift < ActiveRecord::Base
  belongs_to :resource
  belongs_to :messenger
end
