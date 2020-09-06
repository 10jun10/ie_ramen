class Noodle < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :maker, length: { maximum: 30 }
  validates :taste, presence: true, length: { maximum: 50 }
  validates :place, length: { maximum: 30 }
  validates :eat, length: { maximum: 200 }
  mount_uploader :image, ImageUploader

  def create_notification_favorite!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and noodle_id = ? and action = ?",
                                current_user.id, user_id, id, 'favorite'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        noodle_id: id,
        visited_id: user_id,
        action: 'favorite'
      )

      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(noodle_id: id).where.not(user_id: current_user.id).distinct

    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, user_id)
    notification = current_user.active_notifications.new(
      noodle_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )

    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
