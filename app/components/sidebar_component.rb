# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  def initialize(controller:)
    @controller = controller
  end

  def active_class?(controller_name)
    controller.controller_name == controller_name ? "active" : ""
  end

  attr_reader :controller
end
