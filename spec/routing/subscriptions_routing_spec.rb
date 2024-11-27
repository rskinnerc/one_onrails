require "rails_helper"

RSpec.describe SubscriptionsController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/account/subscription").to route_to("subscriptions#show")
    end

    it "routes to #new" do
      expect(get: "/account/subscription/new").to route_to("subscriptions#new")
    end

    it "routes to #edit" do
      expect(get: "/account/subscription/edit").to route_to("subscriptions#edit")
    end

    it "routes to #create" do
      expect(post: "/account/subscription").to route_to("subscriptions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/subscription").to route_to("subscriptions#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/subscription").to route_to("subscriptions#update")
    end

    it "routes to #destroy" do
      expect(delete: "/account/subscription").to route_to("subscriptions#destroy")
    end
  end
end
