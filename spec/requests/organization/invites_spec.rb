require 'rails_helper'

require_relative '../../support/shared_contexts/logged_in'
require_relative '../../support/shared_examples/not_logged_in'

RSpec.describe "/organization/:organization_id/invites", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:policy) { nil }

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  before do
    allow(OrganizationPolicy).to receive(:new).and_return(policy)
  end

  describe "GET /index" do
    let(:do_request) { get organization_invites_url(organization) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      it "renders a successful response" do
      end

      it "renders a list of pending and rejected invites" do
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
        it "renders a successful response" do
        end

        it "renders the invite details" do
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
