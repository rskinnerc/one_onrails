require 'rails_helper'

RSpec.describe User::Setting, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:theme).with_values(light: 0, night: 1) }
  end
end
