require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:subscriptions) }
  end

  describe 'scopes' do
    describe '.initial_subscription' do
      let!(:plan) { create(:plan, initial_subscription: true) }

      it 'returns the plan with initial_subscription set to true' do
        expect(Plan.initial_subscription).to eq(plan)
      end
    end
  end
end
