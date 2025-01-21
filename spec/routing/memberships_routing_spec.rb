require "rails_helper"

RSpec.describe MembershipsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/organizations/2/memberships").to route_to("memberships#index", organization_id: "2")
    end

    it "routes to #edit" do
      expect(get: "/organizations/2/memberships/1/edit").to route_to("memberships#edit", id: "1", organization_id: "2")
    end

    it "routes to #update via PUT" do
      expect(put: "/organizations/2/memberships/1").to route_to("memberships#update", id: "1", organization_id: "2")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/organizations/2/memberships/1").to route_to("memberships#update", id: "1", organization_id: "2")
    end

    it "routes to #destroy" do
      expect(delete: "/organizations/2/memberships/1").to route_to("memberships#destroy", id: "1", organization_id: "2")
    end
  end
end
