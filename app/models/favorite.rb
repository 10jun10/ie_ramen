class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :noodle
  validates :user_id, presence: true
  validates :noodle_id, presence: true
end
