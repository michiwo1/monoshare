class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  validates :user_id, presence: true
  validates :tittle, presence: true
  validates :share_start_date, presence: true
  validates :share_end_date, presence: true
  has_many :rentals
  has_many :notifications, dependent: :destroy
  has_many :favorites
  has_many :comments,dependent: :destroy


  def rentaled_by?(user)
        rentals.where(user_id: user.id).exists?
  end

  def notification_comment(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(item_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      item_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def notification_favorite(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def notification_apply(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, user_id, id, 'apply'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: user_id,
        action: 'apply'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def notification_cancel(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, user_id, id, 'cancel'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: user_id,
        action: 'cancel'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def notification_approve(current_user)
    rental = rentals.last
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, rental.user_id, id, 'approve'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: rental.user_id,
        action: 'approve'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def notification_reject(current_user)
    rental = rentals.last
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, rental.user_id, id, 'reject'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: rental.user_id,
        action: 'reject'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def notification_complete(current_user)
    rental = rentals.last
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, rental.user_id, id, 'complete'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: rental.user_id,
        action: 'complete'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def favorited_by?(user)
        favorites.where(user_id: user.id).exists?
  end

end
