class User < ApplicationRecord
  has_many :noodles, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :introduction, length: { maximum: 255 }
  has_secure_password

  def favorite(noodle)
    Favorite.create!(user_id: id, noodle_id: noodle.id)
  end

  def unfavorite(noodle)
    Favorite.find_by(user_id: id, noodle_id: noodle.id).destroy
  end

  def favorite?(noodle)
    !Favorite.find_by(user_id: id, noodle_id: noodle.id).nil?
  end
end
