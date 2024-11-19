require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_one_attached(:avatar) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    context "when phone is present" do
      before { allow(subject).to receive(:phone).and_return("1234567890") }
      it { is_expected.to validate_presence_of(:country) }
    end

    context "when phone is not present" do
      before { allow(subject).to receive(:phone).and_return(nil) }
      it { is_expected.to_not validate_presence_of(:country) }
    end
  end
end
