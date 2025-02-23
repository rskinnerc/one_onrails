# frozen_string_literal: true

class Icons::RefreshComponent < ViewComponent::Base
  def initialize(classes: "", id: nil)
    @classes = classes
    @id = id
  end

  private

  attr_reader :classes, :id
end
