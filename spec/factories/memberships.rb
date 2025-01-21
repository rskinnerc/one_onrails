FactoryBot.define do
  factory :membership do
    user
    organization
    role { 0 }
  end
end
