FactoryBot.define do
  factory :address do
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    country { Faker::Address.country_code }
    state { Faker::Address.state_abbr }
    postal_code { Faker::Address.zip_code }
    default { true }
    user
  end
end
