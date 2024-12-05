# frozen_string_literal: true

class Subscription::StatusBadgeComponent < ViewComponent::Base
  def initialize(subscription:)
    @subscription = subscription
  end

  def humanized_status
    case subscription&.status
    when "trialing"
      "In Trial"
    when "active"
      "Active"
    when "paused"
      "Paused"
    when "canceled"
      "Canceled"
    when "expired"
      "Expired"
    else
      "Inactive"
    end
  end

  def status_color
    case subscription&.status
    when "trialing"
      "badge-info text-info"
    when "active"
      "badge-success text-success"
    when "paused"
      "badge-warning text-warning"
    when "canceled"
      "badge-error text-error"
    when "expired"
      "badge-error text-error"
    else
      "badge-gray-500 text-gray-500"
    end
  end

  private

  attr_reader :subscription
end
