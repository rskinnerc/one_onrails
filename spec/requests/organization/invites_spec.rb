require 'rails_helper'

require_relative '../../support/shared_contexts/logged_in'
require_relative '../../support/shared_examples/not_logged_in'

RSpec.describe "/organization/:organization_id/invites", type: :request do
  let(:organization) { create(:organization) }
  let(:membership) { create(:membership, organization: organization, user: user, role: role) }
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:policy) { nil }
  let(:role) { "owner" }

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  before do
    membership
    allow(OrganizationPolicy).to receive(:new).and_return(policy)
  end

  describe "GET /index" do
    let(:do_request) { get organization_invites_url(organization) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      let(:pending_invite) { create(:organization_invite, organization: organization, status: "pending") }
      let(:declined_invite) { create(:organization_invite, organization: organization, status: "declined") }
      let(:accepted_invite) { create(:organization_invite, organization: organization, status: "accepted") }

      include_context "when user is logged in"

      before do
        pending_invite
        declined_invite
        accepted_invite
      end

      it "renders a successful response" do
        do_request
        expect(response).to be_successful
      end

      it "renders a list of pending and declined invites" do
        do_request
        expect(response.body).to include(pending_invite.email)
        expect(response.body).to include(declined_invite.email)
      end

      it "does not render a list of accepted invites" do
        do_request
        expect(response.body).not_to include(accepted_invite.email)
      end

      context "when the organization is not found" do
        let(:membership) { nil }

        it "returns a 404" do
          do_request
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe "GET /show" do
    let(:invite) { create(:organization_invite, organization: organization) }
    let(:do_request) { get organization_invite_url(organization, invite) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user has access to the invite" do
        let(:policy) { instance_double("OrganizationPolicy", list_memberships?: true) }

        it "renders a successful response" do
          do_request
          expect(response).to be_successful
        end

        it "renders the invite details" do
          do_request
          expect(response.body).to include(invite.email)
        end

        context "when the invite does not belong to the organization" do
          let(:invite) { create(:organization_invite) }

          it "returns a 404" do
            do_request
            expect(response).to have_http_status(404)
          end
        end
      end

      context "when the user does not have access to the invite" do
        let(:policy) { instance_double("OrganizationPolicy", list_memberships?: false) }

        it "redirects to the organization invites page" do
          do_request
          expect(response).to redirect_to(organization_invites_url(organization))
        end

        it "displays a flash message" do
          do_request
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end
  end

  describe "GET /new" do
    let(:do_request) { get new_organization_invite_url(organization) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user can invite users to the organization" do
        it "renders a successful response" do
        end
      end

      context "when the user cannot invite users to the organization" do
        it "redirects to the organization invites page" do
        end
      end
    end
  end

  describe "GET /edit" do
    let(:invite) { create(:organization_invite, organization: organization) }
    let(:do_request) { get edit_organization_invite_url(organization, invite) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user has access to the invite" do
        it "renders a successful response" do
        end
      end

      context "when the user does not have access to the invite" do
        it "redirects to the organization invites page" do
        end

        it "displays a flash message" do
        end
      end
    end
  end

  describe "POST /create" do
    let(:do_request) { post organization_invites_url(organization), params: params }
    let(:params) { {} }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user can invite users to the organization" do
        context "with valid parameters" do
        end

        context "with invalid parameters" do
        end
      end

      context "when the user cannot invite users to the organization" do
        it "redirects to the organization invites page" do
        end

        it "displays a flash message" do
        end
      end
    end
  end

  describe "PATCH /update" do
    let(:invite) { create(:organization_invite, organization: organization) }
    let(:do_request) { patch organization_invite_url(organization, invite), params: params }
    let(:params) { {} }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user has access to the invite" do
        before do
          allow(OrganizationPolicy).to receive(:new).and_return(policy)
        end
        context "with valid parameters" do
        end

        context "with invalid parameters" do
        end
      end

      context "when the user does not have access to the invite" do
        it "redirects to the organization invites page" do
        end

        it "displays a flash message" do
        end
      end
    end
  end

  describe "DELETE /destroy" do
    let(:invite) { create(:organization_invite, organization: organization) }
    let(:do_request) { delete organization_invite_url(organization, invite) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user has access to the invite" do
        it "destroys the requested invite" do
        end

        it "redirects to the organization invites list" do
        end
      end

      context "when the user does not have access to the invite" do
        it "redirects to the organization invites page" do
        end

        it "displays a flash message" do
        end
      end
    end
  end
end
