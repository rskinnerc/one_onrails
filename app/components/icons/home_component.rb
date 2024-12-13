# frozen_string_literal: true

class Icons::HomeComponent < ViewComponent::Base
  def initialize(classes: "", id: "")
    @classes = classes
  end

  attr_reader :classes, :id
end
