require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'associations' do
    it { should belong_to(:subscription).optional }
    it { should belong_to(:user) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, completed: 1, failed: 2, canceled: 3) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount_cents) }
    it { should validate_presence_of(:tax_amount_cents) }
    it { should validate_presence_of(:total_amount_cents) }
    it { should validate_numericality_of(:tax_amount_cents).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:total_amount_cents).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:currency) }
    it { should validate_numericality_of(:tax_rate).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:tax_rate).is_less_than_or_equal_to(100) }
  end
end
