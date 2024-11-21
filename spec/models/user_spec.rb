require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_one(:profile).dependent(:destroy) }
    it { should have_secure_password }
    it { should have_many(:addresses).dependent(:destroy) }
    it { should have_one(:default_address).conditions(default: true).class_name("Address") }
    it { should have_one(:subscription).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to normalize(:email_address).from("Test@TEST.com").to("test@test.com") }
    it { is_expected.to validate_presence_of(:email_address) }
  end
end
