# frozen_string_literal: true

class Icons::CloseCircleComponent < ViewComponent::Base
  def initialize(classes: "", id: "")
    @classes = classes
    @id = id
  end

  attr_reader :classes, :id
end
