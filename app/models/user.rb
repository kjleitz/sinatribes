class User < ActiveRecord::Base
  has_many :tribes

  has_secure_password
  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :password
end
