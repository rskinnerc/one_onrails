require "rails_helper"

RSpec.describe AddressesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/account/addresses").to route_to("addresses#index")
    end

    it "routes to #new" do
      expect(get: "/account/addresses/new").to route_to("addresses#new")
    end

    it "routes to #show" do
      expect(get: "/account/addresses/1").to route_to("addresses#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/account/addresses/1/edit").to route_to("addresses#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/account/addresses").to route_to("addresses#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/addresses/1").to route_to("addresses#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/addresses/1").to route_to("addresses#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/account/addresses/1").to route_to("addresses#destroy", id: "1")
    end

    it "routes to #make_default" do
      expect(patch: "/account/addresses/1/make_default").to route_to("addresses#make_default", id: "1")
    end
  end
end
