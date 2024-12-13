# frozen_string_literal: true

class Icons::MoonStarsComponent < ViewComponent::Base
  def initialize(classes: "", id: "")
    @classes = classes
    @id = id
  end

  attr_reader :classes, :id
end
