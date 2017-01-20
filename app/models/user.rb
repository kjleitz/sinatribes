class User < ActiveRecord::Base
  has_many :tribes
  belongs_to :tribe

  has_secure_password
  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true
  validates :username, format: {
    with: /\A\w{1,80}\z/,
    message: "may only contain letters, numbers, and underscores, and be less than 80 characters in length."
  }
  validates :email, format: {
    with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "must be valid"
  }

  def switch_active_tribe_to(tribe)
    self.update(tribe: tribe) if self.tribes.include?(tribe)
  end

end
