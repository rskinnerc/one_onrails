require "rails_helper"

RSpec.describe SettingsController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/account/settings").to route_to("settings#show")
    end

    it "routes to #edit" do
      expect(get: "/account/settings/edit").to route_to("settings#edit")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/settings").to route_to("settings#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/settings").to route_to("settings#update")
    end
  end
end
