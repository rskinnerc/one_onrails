require 'rails_helper'

RSpec.shared_examples "when user is not logged in" do
  it "redirects to the login page" do
    do_request
    expect(response).to redirect_to(new_session_path)
  end
end

RSpec.shared_context "when user is logged in" do
  before do
    allow(Current).to receive(:session).and_return(session)
  end
end

RSpec.describe "/memberships", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    let(:do_request) { get organization_memberships_url(organization) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when user is a member of the organization" do
        let(:existing_memberships) { create_list(:membership, 3, organization: organization) }
        before do
          create(:membership, user: user, organization: organization)
          existing_memberships
        end

        it "renders a successful response" do
          do_request
          expect(response).to be_successful
        end

        it "renders a turbo frame tag with correct organization id" do
          do_request
          expect(response.body).to include("turbo-frame id=\"#{organization.id}_memberships\"")
        end

        it "renders a list of memberships by user email" do
          do_request
          existing_memberships.each do |membership|
            expect(response.body).to include(membership.user.email_address)
          end
        end
      end

      context "when user is not a member of the organization" do
        it "returns a not found response" do
          do_request
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when the organization does not exist" do
        let(:do_request) { get organization_memberships_url(0) }

        it "returns a not found response" do
          do_request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_membership_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      membership = Membership.create! valid_attributes
      get edit_membership_url(membership)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Membership" do
        expect {
          post memberships_url, params: { membership: valid_attributes }
        }.to change(Membership, :count).by(1)
      end

      it "redirects to the created membership" do
        post memberships_url, params: { membership: valid_attributes }
        expect(response).to redirect_to(membership_url(Membership.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Membership" do
        expect {
          post memberships_url, params: { membership: invalid_attributes }
        }.to change(Membership, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post memberships_url, params: { membership: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested membership" do
        membership = Membership.create! valid_attributes
        patch membership_url(membership), params: { membership: new_attributes }
        membership.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the membership" do
        membership = Membership.create! valid_attributes
        patch membership_url(membership), params: { membership: new_attributes }
        membership.reload
        expect(response).to redirect_to(membership_url(membership))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        membership = Membership.create! valid_attributes
        patch membership_url(membership), params: { membership: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested membership" do
      membership = Membership.create! valid_attributes
      expect {
        delete membership_url(membership)
      }.to change(Membership, :count).by(-1)
    end

    it "redirects to the memberships list" do
      membership = Membership.create! valid_attributes
      delete membership_url(membership)
      expect(response).to redirect_to(memberships_url)
    end
  end
end
