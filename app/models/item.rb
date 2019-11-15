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

  validate :check_share_date

  def check_share_date
    if share_start_date.nil? || share_end_date.nil?
      errors.add(:start_date, 'シェア開始日は本日以降の日付にできません')
    end
  end

  def rentaled_by?(user)
        rentals.where(user_id: user.id).exists?
  end

  def notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    comment_user_ids = comments.select(:user_id).where.not(user_id: current_user.id).distinct.pluck(:user_id)
    comment_user_ids.each do |comment_user_id|
      save_notification_comment!(current_user, comment_id, comment_user_id)
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if comment_user_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      item_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def notification_favorite(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
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

  def notification_approve(current_user)
    rental = rentals.last
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, rental.user_id, id, 'approve'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: rental.user_id,
        action: 'approve'
      )
    # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def notification_reject(current_user)
    rental = rentals.last
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, rental.user_id, id, 'reject'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: rental.user_id,
        action: 'reject'
      )
    # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def notification_complete(current_user)
    rental = rentals.last
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, rental.user_id, id, 'complete'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        item_id: id,
        visited_id: rental.user_id,
        action: 'complete'
      )
    # 自分の投稿に対するいいねの場合は、通知済みとする
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
