class Noodle < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :maker, length: { maximum: 30 }
  validates :place, length: { maximum: 30 }
  validates :eat, length: { maximum: 200 }
  mount_uploader :image, ImageUploader
end
