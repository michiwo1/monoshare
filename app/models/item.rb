class Item < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  def user
    return User.find_by(id: self.user_id)
  end
end
