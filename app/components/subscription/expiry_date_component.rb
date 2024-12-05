# frozen_string_literal: true

class Subscription::ExpiryDateComponent < ViewComponent::Base
  def initialize(subscription:)
    @subscription = subscription
  end

  def trialing?
    subscription&.trialing?
  end

  def expiry_date
    return susbcription.trial_end_date if trialing?

    subscription&.end_date
  end

  private

  attr_reader :subscription
end
