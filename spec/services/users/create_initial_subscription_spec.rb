require 'rails_helper'

RSpec.describe Users::CreateInitialSubscription do
  let(:subject) { described_class.call(user: user) }
  let(:user) { create(:user) }
  let!(:plan) { create(:plan, initial_subscription: true) }

  context 'when subscription at sign up is enabled' do
    before do
      Flipper.enable(:subscription_at_sign_up)
    end

    it 'creates a subscription for the user' do
      expect { subject }.to change { Subscription.count }.by(1)
    end

    it 'returns a successful result' do
      expect(subject.success?).to be true
    end

    it 'creates a subscription with the initial plan' do
      subject

      expect(user.subscription.plan).to eq(plan)
    end

    context 'when the user is nil' do
      let(:user) { nil }

      it 'returns an unsuccessful result' do
        expect(subject.success?).to be false
      end

      it 'returns the correct error message' do
        expect(subject.errors).to eq([ 'User is required' ])
      end
    end
  end

  context 'when subscription at sign up is not enabled' do
    before do
      Flipper.disable(:subscription_at_sign_up)
    end

    it 'returns an unsuccessful result' do
      expect(subject.success?).to be false
    end

    it 'does not create a subscription for the user' do
      expect { subject }.not_to change { Subscription.count }
    end

    context 'when the user is nil' do
      let(:user) { nil }

      it 'returns an unsuccessful result' do
        expect(subject.success?).to be false
      end
    end

    it 'returns the correct error message' do
      expect(subject.errors).to eq([ 'Subscription at sign up is not enabled' ])
    end
  end
end
