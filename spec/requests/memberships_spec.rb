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
        let(:membership) { create(:membership, user: user, organization: organization) }

        before do
          membership
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

        it "does not render the edit button for the user's membership" do
          do_request
          expect(response.body).not_to include(edit_organization_membership_path(organization, membership))
        end

        it "does not render the new membership button" do
          do_request
          expect(response.body).not_to include("Invite member")
        end

        context "when the user is owner of the organization" do
          before do
            membership.update(role: "owner")
          end

          it "renders the new membership button" do
            do_request
            expect(response.body).to include("Invite member")
          end

          it "renders the edit button for the user's membership" do
            do_request
            existing_memberships.each do |membership|
              expect(response.body).to include(edit_organization_membership_path(organization, membership))
            end
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

  describe "GET /edit" do
    let(:do_request) { get edit_organization_membership_path(organization, membership) }
    let(:membership) { create(:membership, organization: organization) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user is owner of the organization" do
        before do
          create(:membership, user: user, organization: organization, role: "owner")
        end

        it "renders a successful response" do
          do_request
          expect(response).to be_successful
        end

        it "renders the edit member view" do
          do_request
          expect(response.body).to include("Change member role")
        end

        it "renders a turbo frame tag with correct organization id" do
          do_request
          expect(response.body).to include("turbo-frame id=\"#{organization.id}_memberships\"")
        end

        it "renders the back to memberships link" do
          do_request
          expect(response.body).to include("Back to memberships")
        end

        context "when the organization does not exist" do
          let(:do_request) { get edit_organization_membership_path(0, membership) }

          it "returns a not found response" do
            do_request
            expect(response).to have_http_status(:not_found)
          end
        end

        context "when the membership does not exist" do
          let(:do_request) { get edit_organization_membership_path(organization, 0) }

          it "returns a not found response" do
            do_request
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context "when the user is not owner of the organization" do
        %w[member admin].each do |role|
          context "when the user is a #{role}" do
            before do
              create(:membership, user: user, organization: organization, role: role)
            end

            it "redirects to the memberships index page" do
              do_request
              expect(response).to redirect_to(organization_memberships_url(organization))
            end

            it "displays an alert message" do
              do_request
              expect(flash[:alert]).to eq("You are not authorized to perform this action.")
            end
          end
        end
      end

      context "when the user is not a member of the organization" do
        it "returns a not found response" do
          do_request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "PATCH /update" do
    let(:do_request) { patch organization_membership_path(organization, membership), params: params }
    let(:membership) { create(:membership, organization: organization, role: role) }
    let(:params) { {} }
    let(:role) { "member" }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user is owner of the organization" do
        before do
          create(:membership, user: user, organization: organization, role: "owner")
        end

        context "with valid parameters" do
          let(:params) { { membership: { role: "admin" } } }

          it "updates the requested membership" do
            do_request
            membership.reload
            expect(membership.role).to eq("admin")
          end

          it "redirects to the memberships list" do
            do_request
            expect(response).to redirect_to(organization_memberships_url(organization))
          end
        end

        context "with invalid parameters" do
          let(:params) { { membership: { role: nil } } }

          it 'returns an unprocessable entity response' do
            do_request
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it "renders the edit member view" do
            do_request
            expect(response.body).to include("Change member role")
          end

          it "renders a turbo frame tag with correct organization id" do
            do_request
            expect(response.body).to include("turbo-frame id=\"#{organization.id}_memberships\"")
          end
        end

        context "when the organization does not exist" do
          let(:do_request) { patch organization_membership_path(0, membership), params: params }

          it "returns a not found response" do
            do_request
            expect(response).to have_http_status(:not_found)
          end
        end

        context "when the membership does not exist" do
          let(:do_request) { patch organization_membership_path(organization, 0), params: params }

          it "returns a not found response" do
            do_request
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context "when the user is not owner of the organization" do
        before do
          create(:membership, user: user, organization: organization, role: "admin")
        end

        it "redirects to the memberships index page" do
          do_request
          expect(response).to redirect_to(organization_memberships_url(organization))
        end

        it "displays an alert message" do
          do_request
          expect(flash[:alert]).to eq("You are not authorized to perform this action.")
        end
      end
    end
  end

  describe "DELETE /destroy" do
    let(:do_request) { delete organization_membership_path(organization, membership) }
    let(:membership) { create(:membership, organization: organization) }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when the user is owner of the organization" do
        before do
          create(:membership, user: user, organization: organization, role: "owner")
        end

        it "destroys the requested membership" do
          do_request
          expect { membership.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "redirects to the memberships list" do
          do_request
          expect(response).to redirect_to(organization_memberships_url(organization))
        end

        context "when the organization does not exist" do
          let(:do_request) { delete organization_membership_path(0, membership) }

          it "returns a not found response" do
            do_request
            expect(response).to have_http_status(:not_found)
          end
        end

        context "when the membership does not exist" do
          let(:do_request) { delete organization_membership_path(organization, 0) }

          it "returns a not found response" do
            do_request
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context "when the user is not owner of the organization" do
        before do
          create(:membership, user: user, organization: organization, role: "admin")
        end

        it "redirects to the memberships index page" do
          do_request
          expect(response).to redirect_to(organization_memberships_url(organization))
        end

        it "displays an alert message" do
          do_request
          expect(flash[:alert]).to eq("You are not authorized to perform this action.")
        end
      end
    end
  end
end
