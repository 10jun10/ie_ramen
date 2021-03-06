class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :noodle
  has_many :notifications, dependent: :destroy
  validates :user_id, presence: true
  validates :noodle_id, presence: true
  validates :content, presence: true, length: { maximum: 100 }
end
