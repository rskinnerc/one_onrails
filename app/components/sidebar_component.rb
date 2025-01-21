# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  def initialize(controller:)
    @controller = controller
  end

  def active_class?(controller_names)
   controller_names = controller_names.is_a?(String) ? [ controller_names ] : controller_names

   controller_names.include?(controller.controller_name) ? "active" : ""
  end

  attr_reader :controller
end
