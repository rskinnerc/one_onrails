module SettingsHelper
  def theme_for(user)
    user&.setting&.theme || "winter"
  end
end
