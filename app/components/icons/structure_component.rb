# frozen_string_literal: true

class Icons::StructureComponent < ViewComponent::Base
  def initialize(classes: "", id: nil)
    @classes = classes
    @id = id
  end

  attr_reader :classes, :id
end
