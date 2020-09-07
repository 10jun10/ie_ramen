FactoryBot.define do
  factory :notification do
    visitor_id { 1 }
    visited_id { 2 }
    noodle_id { 1 }
    action { "favorite" }
  end
end
