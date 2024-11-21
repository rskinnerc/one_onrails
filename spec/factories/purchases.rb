FactoryBot.define do
  factory :purchase do
    subscription { nil }
    user { nil }
    amount_cents { 1 }
    tax_amount_cents { 1 }
    tax_rate { "9.99" }
    total_amount_cents { 1 }
    currency { "MyString" }
    description { "MyString" }
    status { 1 }
  end
end
