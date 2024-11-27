require 'rails_helper'

RSpec.describe BillingHistory, type: :model do
  describe "associations" do
    it { should belong_to(:subscription) }
    it { should belong_to(:user) }
  end
end
