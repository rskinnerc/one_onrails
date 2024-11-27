FactoryBot.define do
  factory :purchase do
    subscription { nil }
    user
    amount_cents { 100 }
    tax_amount_cents { 10 }
    tax_rate { 10.00 }
    total_amount_cents { 110 }
    currency { "USD" }
    description { "My Puschase" }
    status { 0 }
  end
end
