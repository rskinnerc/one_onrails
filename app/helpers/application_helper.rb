module ApplicationHelper
  def registrations_enabled?
    Flipper.enabled?(:registrations)
  end

  def theme
    current_user&.setting&.theme || "winter"
  end
end
