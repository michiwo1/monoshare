class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  validates :user_id, presence: true
  has_many :rentals
  has_many :notifications, dependent: :destroy

  def rentaled_by?(user)
        rentals.where(user_id: user.id).exists?
  end

  def notification_apply(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, user_id, id, 'apply'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: user_id,
        action: 'apply'
      )
    # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def notification_cancel(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, user_id, id, 'cancel'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: user_id,
        action: 'cancel'
      )
    # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

end
