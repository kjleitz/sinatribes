class Messenger < ActiveRecord::Base

  include Formatter

  has_one :gift
  belongs_to :tribe
  belongs_to :destination, foreign_key: :destination_id, class_name: 'Tribe'

  after_create :initialize_with_gift

  def initialize_with_gift
    self.update(gift: Gift.create) unless self.gift
  end

  def rejected?
    self.rejected
  end

  def reject
    self.update(rejected: true) unless rejected?
  end

  def give_message(msg)
    self.update(message: msg)
  end

  def created_at_formatted
    format_time(self.created_at, true)
  end
end
