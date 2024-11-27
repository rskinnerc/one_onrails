require "rails_helper"

RSpec.describe SubscriptionsController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/account/subscription").to route_to("subscriptions#show")
    end
  end
end
