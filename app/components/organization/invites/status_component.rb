# frozen_string_literal: true

class Organization::Invites::StatusComponent < ViewComponent::Base
  def initialize(status:)
    @status = status
  end

  def humanized_status
    status.humanize
  end

  def status_class
    case status
    when "pending"
      "badge-warning"
    when "accepted"
      "badge-success"
    when "declined"
      "badge-error"
    end
  end

  private

  attr_reader :status
end
