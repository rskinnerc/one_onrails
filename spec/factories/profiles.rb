FactoryBot.define do
  factory :profile do
    first_name { "MyString" }
    last_name { "MyString" }
    phone { "MyString" }
    avatar { nil }
    country { "MyString" }
    user { nil }
  end
end
