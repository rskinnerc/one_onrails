require "rails_helper"

RSpec.describe Organization::InvitesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/organizations/1/invites").to route_to("organization/invites#index", organization_id: "1")
    end

    it "routes to #new" do
      expect(get: "/organizations/1/invites/new").to route_to("organization/invites#new", organization_id: "1")
    end

    it "routes to #show" do
      expect(get: "/organizations/1/invites/1").to route_to("organization/invites#show", id: "1", organization_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/organizations/1/invites/1/edit").to route_to("organization/invites#edit", id: "1", organization_id: "1")
    end

    it "routes to #create" do
      expect(post: "/organizations/1/invites").to route_to("organization/invites#create", organization_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/organizations/1/invites/1").to route_to("organization/invites#update", id: "1", organization_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/organizations/1/invites/1").to route_to("organization/invites#update", id: "1", organization_id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/organizations/1/invites/1").to route_to("organization/invites#destroy", id: "1", organization_id: "1")
    end
  end
end
