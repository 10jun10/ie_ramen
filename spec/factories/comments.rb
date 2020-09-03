FactoryBot.define do
  factory :comment do
    content { "私もよく食べます" }
    association :user
    association :noodle
  end
end
