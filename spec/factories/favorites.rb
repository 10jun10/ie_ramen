FactoryBot.define do
  factory :favorite do
    association :user
    association :noodle
  end
end
