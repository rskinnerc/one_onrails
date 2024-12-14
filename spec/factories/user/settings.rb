FactoryBot.define do
  factory :user_setting, class: 'User::Setting' do
    user
    theme { 0 }
  end
end
