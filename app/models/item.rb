class Item < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  def items
    return Item.find_by(user_id: self.id)
  end
end
