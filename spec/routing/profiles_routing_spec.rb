require "rails_helper"

RSpec.describe ProfilesController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/account/profile/new").to route_to("profiles#new")
    end

    it "routes to #show" do
      expect(get: "/account/profile").to route_to("profiles#show")
    end

    it "routes to #edit" do
      expect(get: "/account/profile/edit").to route_to("profiles#edit")
    end

    it "routes to #create" do
      expect(post: "/account/profile").to route_to("profiles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/profile").to route_to("profiles#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/profile").to route_to("profiles#update")
    end

    it "routes to #destroy" do
      expect(delete: "/account/profile").to route_to("profiles#destroy")
    end
  end
end
