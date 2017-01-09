class Resource < ActiveRecord::Base
  belongs_to :tribe
  belongs_to :gift

  def self.discover
    self.create(name: self.all.reject { |r| r.name == "cloth" }.sample.name)
  end

end
