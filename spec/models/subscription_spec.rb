require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:purchases) }
    it { should belong_to(:plan) }
    it { should have_many(:billing_histories) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values(trialing: 0, active: 1, paused: 2, canceled: 3, expired: 4) }
  end
end
