FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.email }
    password { 'password123' }

    trait :with_subscription do
      after :create do |user|
        create :subscription, user: user
      end
    end

    trait :with_purchase do
      after :create do |user|
        create :purchase, user: user
      end
    end
  end
end
