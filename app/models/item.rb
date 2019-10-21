class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  validates :user_id, presence: true
  has_many :rentals


  def rentaled_by?(user)
        rentals.where(user_id: user.id).exists?
  end




end
