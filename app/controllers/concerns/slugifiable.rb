module Slugifiable

  # you can use attribute=:username if you need to do a username, etc.
  def slug(attribute=:name)
    self.send(attribute).downcase.gsub(/\W+/, "-")
  end

  def self.find_by_slug(slug, attribute=:name)
    self.all.find { |e| e.slug(attribute) == slug }
  end
end
