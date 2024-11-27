FactoryBot.define do
  factory :billing_history do
    subscription { nil }
    amount_cents { 1 }
    currency { "MyString" }
    event_type { 1 }
    event_date { "2024-11-23 05:14:12" }
    metadata { "MyText" }
    tax_amount_cents { 1 }
    total_amount_cents { 1 }
    tax_rate { "9.99" }
    user { nil }
  end
end
