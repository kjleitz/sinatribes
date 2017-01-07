module Slugifiable

  module InstanceMethods
    # you can use attribute=:username if you need to do a username, etc.
    def slug(attribute=:name)
      slug = self.send(attribute).downcase.gsub(/\W+/, "-")
      slug + "-" + self.id.to_s unless attribute == :username
    end
  end

  module ClassMethods
    def find_by_slug(slug, attribute=:name)
      self.all.find { |e| e.slug(attribute) == slug }
    end
  end

end
