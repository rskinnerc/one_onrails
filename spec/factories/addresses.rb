FactoryBot.define do
  factory :address do
    address_line_1 { "MyString" }
    address_line_2 { "MyString" }
    city { "MyString" }
    country { "MyString" }
    state { "MyString" }
    postal_code { "MyString" }
    default { false }
  end
end
