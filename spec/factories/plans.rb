FactoryBot.define do
  factory :plan do
    name { "MyString" }
    price_cents { 1 }
    currency { "MyString" }
    trial_duration_days { 1 }
    description { "MyText" }
    public { false }
  end
end
