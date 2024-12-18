FactoryBot.define do
  factory :organization_invite, class: 'Organization::Invite' do
    organization { nil }
    inviter { nil }
    invited_user { nil }
    email { "MyString" }
    status { "MyString" }
    role { "MyString" }
    token { "MyString" }
  end
end
