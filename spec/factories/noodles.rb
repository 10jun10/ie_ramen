FactoryBot.define do
  factory :noodle do
    name { "蒙古タンメン" }
    maker { "日清食品" }
    place { "セブンイレブン" }
    eat { "納豆と一緒に食べる" }
    association :user
    created_at { Time.current }
  end

  trait :yesterday do
    created_at { 1.day.ago }
  end
  trait :two_days_ago do
    created_at { 2.day.ago }
  end
  trait :three_days_ago do
    created_at { 3.day.ago }
  end
end
