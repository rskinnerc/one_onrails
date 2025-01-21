# frozen_string_literal: true

class Memberships::RoleComponent < ViewComponent::Base
  def initialize(role:)
    @role = role
  end

  def humanized_role
    role.humanize
  end

  private

  attr_reader :role
end
