class Notification < ApplicationRecord
  belongs_to :noodle, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visitor_id', optional: true
  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  ACTION_VALUES = ["favorite", "comment"]
  validates :action, presence: true, inclusion: {in: ACTION_VALUES}
  validates :checked, inclusion: {in: [true,false]}
end
