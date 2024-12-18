class Organization::Invite < ApplicationRecord
  belongs_to :organization
  belongs_to :inviter
  belongs_to :invited_user
end
