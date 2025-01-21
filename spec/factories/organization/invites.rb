FactoryBot.define do
  factory :organization_invite, class: 'Organization::Invite' do
    organization
    inviter { association :user }
    invited_user { association :user }
    email { Faker::Internet.email }
    status { 0 }
    role { 0 }
    token { "MyToken" }
  end
end
