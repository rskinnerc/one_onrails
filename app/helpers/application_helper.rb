module ApplicationHelper
  def registrations_enabled?
    Flipper.enabled?(:registrations)
  end
end
