FactoryBot.define do
  factory :noodle do
    name { "蒙古タンメン" }
    maker { "日清食品" }
    place { "セブンイレブン" }
    eat { "納豆と一緒に食べる" }
    association :user
  end
end
