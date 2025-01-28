require "rails_helper"

RSpec.describe Organization::InvitesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/organization/invites").to route_to("organization/invites#index")
    end

    it "routes to #new" do
      expect(get: "/organization/invites/new").to route_to("organization/invites#new")
    end

    it "routes to #show" do
      expect(get: "/organization/invites/1").to route_to("organization/invites#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/organization/invites/1/edit").to route_to("organization/invites#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/organization/invites").to route_to("organization/invites#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/organization/invites/1").to route_to("organization/invites#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/organization/invites/1").to route_to("organization/invites#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/organization/invites/1").to route_to("organization/invites#destroy", id: "1")
    end
  end
end
