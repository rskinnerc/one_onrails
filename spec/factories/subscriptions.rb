FactoryBot.define do
  factory :subscription do
    status { 1 }
    start_date { "2024-11-20 07:43:21" }
    end_date { "2024-11-20 07:43:21" }
    trial_end_date { "2024-11-20 07:43:21" }
    user { nil }
  end
end
