class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true
  mount_uploader :image, ImageUploader
  has_many :items, dependent: :destroy
  has_many :rentals
  has_many :rentals_items, through: :rentals, source: :item
  has_many :favorites
  has_many :favorite_items, through: :favorites, source: :item
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_many :favorite_items, through: :favorites, source: :item
  has_many :comments, dependent: :destroy

end
