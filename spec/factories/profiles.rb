FactoryBot.define do
  factory :profile do
    first_name { "FirstName" }
    last_name { "LastName" }
    phone { Faker::PhoneNumber.cell_phone }
    country { Faker::Address.country_code }
    user

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg'), 'image/jpeg') }
    end
  end
end
