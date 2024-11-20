require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    subject { build(:address) }

    it { is_expected.to validate_uniqueness_of(:default).scoped_to(:user_id) }
  end
end
