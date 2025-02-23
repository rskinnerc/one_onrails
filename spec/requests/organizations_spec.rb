require 'rails_helper'

require_relative '../support/shared_contexts/logged_in'
require_relative '../support/shared_examples/not_logged_in'

RSpec.describe "/organizations", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let!(:organization) { create(:organization) }
  let!(:organization_2) { create(:organization) }

  let(:valid_attributes) {
    {
      organization: {
        name: "My organization"
      }
    }
  }

  let(:invalid_attributes) {
    {
      organization: {
        name: ""
      }
    }
  }

  describe "GET /index" do
    let(:do_request) { get "/organizations" }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      it "returns http success" do
        do_request
        expect(response).to have_http_status(:success)
      end

      context "when user is a member of the organization" do
        before do
          create(:membership, user: user, organization: organization)
        end

        it "displays the organization" do
          do_request
          expect(response.body).to include(organization.name)
        end

        it "does not display other organizations" do
          do_request
          expect(response.body).not_to include(organization_2.name)
        end
      end

      context "when user is not a member of the organization" do
        it "does not display the organization" do
          do_request
          expect(response.body).not_to include(organization.name)
        end
      end
    end
  end

  describe "GET /show" do
    let(:do_request) { get "/organizations/#{organization.id}" }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when user is a member of the organization" do
        before do
          create(:membership, user: user, organization: organization)
        end

        it "returns http success" do
          do_request
          expect(response).to have_http_status(:success)
        end

        it "displays the organization" do
          do_request
          expect(response.body).to include(organization.name)
        end

        it "renders the organization invites turbo frame" do
          do_request
          expect(response.body).to include("turbo-frame id=\"organization_#{organization.id}_invites\"")
        end

        context "when the organization does not exist" do
          let(:do_request) { get "/organizations/0" }

          it "returns http not found" do
            do_request
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context "when user is not a member of the organization" do
        it "returns http not found" do
          do_request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "GET /new" do
    let(:do_request) { get "/organizations/new" }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      it "returns http success" do
        do_request
        expect(response).to have_http_status(:success)
      end

      it "displays the new organization form" do
        do_request
        expect(response.body).to include("New organization")
      end

      context "when user has reached the organization limit" do
        let(:plan) { create(:plan, organizations_limit: 0) }
        let(:subscription) { create(:subscription, user: user, plan: plan) }

        before do
          user.update(subscription: subscription)
        end

        it "does not display the new organization form" do
          do_request
          expect(response.body).not_to include("new_organization_form")
        end

        it "displays a message indicating the organization limit has been reached" do
          do_request
          expect(response.body).to include("You have reached the organization limit.")
        end
      end

      context "when user does not have an active subscription" do
        it "does not display the new organization form" do
          do_request
          expect(response.body).not_to include("new_organization_form")
        end

        it "displays a message indicating the user does not have an active subscription" do
          do_request
          expect(response.body).to include("You have reached the organization limit.")
        end
      end
    end
  end

  describe "GET /edit" do
    let(:do_request) { get "/organizations/#{organization.id}/edit" }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when user is a member of the organization" do
        before do
          create(:membership, user: user, organization: organization, role: role)
        end

        context "when user is an owner of the organization" do
          let(:role) { :owner }

          it "returns http success" do
            do_request
            expect(response).to have_http_status(:success)
          end

          it "displays the edit organization form" do
            do_request
            expect(response.body).to include("Editing organization")
          end
        end

        context "when user is an admin of the organization" do
          let(:role) { :admin }

          it "redirects to the organization page" do
            do_request
            expect(response).to redirect_to(organization_path(organization))
          end

          it "displays a flash alert" do
            do_request
            expect(flash[:alert]).to eq("You are not authorized to perform this action.")
          end
        end

        context "when user is not an admin of the organization" do
          let(:role) { :member }

          it "redirects to the organization page" do
            do_request
            expect(response).to redirect_to(organization_path(organization))
          end

          it "displays a flash alert" do
            do_request
            expect(flash[:alert]).to eq("You are not authorized to perform this action.")
          end
        end
      end

      context "when user is not a member of the organization" do
        it "returns http not found" do
          do_request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "POST /create" do
    let(:do_request) { post "/organizations", params: params }
    let(:params) { valid_attributes }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when user has reached the organization limit" do
        let(:plan) { create(:plan, organizations_limit: 0) }
        let(:subscription) { create(:subscription, user: user, plan: plan) }

        before do
          user.update(subscription: subscription)
        end

        it "does not create a new Organization" do
          expect {
            do_request
          }.not_to change(Organization, :count)
        end

        it "redirects to the organizations page" do
          do_request
          expect(response).to redirect_to(organizations_path)
        end

        it "displays a flash alert" do
          do_request
          expect(flash[:alert]).to eq("You have reached the organization limit.")
        end
      end

      context "when user does not have an active subscription" do
        it "does not create a new Organization" do
          expect {
            do_request
          }.not_to change(Organization, :count)
        end

        it "redirects to the organizations page" do
          do_request
          expect(response).to redirect_to(organizations_path)
        end

        it "displays a flash alert" do
          do_request
          expect(flash[:alert]).to eq("You have reached the organization limit.")
        end
      end

      context "when the user has an active subscription and has not reached the organization limit" do
        let(:subscription) { create(:subscription, user: user, plan: plan) }
        let(:plan) { create(:plan, organizations_limit: 10) }

        before do
          user.update(subscription: subscription)
        end

        it "creates a new Organization" do
          expect {
            do_request
          }.to change(Organization, :count).by(1)
        end

        it "redirects to the created organization" do
          do_request
          expect(response).to redirect_to(Organization.last)
        end

        it "displays a flash notice" do
          do_request
          expect(flash[:notice]).to eq("Organization was successfully created.")
        end

        it "creates a membership for the user" do
          expect {
            do_request
          }.to change(Membership, :count).by(1)
        end

        it "sets the membership role to owner" do
          do_request
          expect(Membership.last.role).to eq("owner")
        end

        context "with invalid parameters" do
          let(:params) { invalid_attributes }

          it "does not create a new Organization" do
            expect {
              do_request
            }.not_to change(Organization, :count)
          end

          it "returns http unprocessable entity" do
            do_request
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end

  describe "PATCH /update" do
    let(:do_request) { patch "/organizations/#{organization.id}", params: params }
    let(:params) { valid_attributes }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when user is a member of the organization" do
        let(:membership) { create(:membership, user: user, organization: organization, role: role) }

        before do
          membership
        end

        context "when user is an owner of the organization" do
          let(:role) { :owner }

          it "updates the Organization" do
            do_request
            organization.reload
            expect(organization.name).to eq("My organization")
          end

          it "redirects to the organization" do
            do_request
            expect(response).to redirect_to(organization)
          end

          context "with invalid parameters" do
            let(:params) { invalid_attributes }

            it "does not update the Organization" do
              do_request
              organization.reload
              expect(organization.name).not_to eq("")
            end

            it "returns http unprocessable entity" do
              do_request
              expect(response).to have_http_status(:unprocessable_entity)
            end
          end
        end

        context "when user is an admin of the organization" do
          let(:role) { :admin }

          it "redirects to the organization page" do
            do_request
            expect(response).to redirect_to(organization_path(organization))
          end

          it "displays a flash alert" do
            do_request
            expect(flash[:alert]).to eq("You are not authorized to perform this action.")
          end
        end

        context "when user is not an admin of the organization" do
          let(:role) { :member }

          it "redirects to the organization page" do
            do_request
            expect(response).to redirect_to(organization_path(organization))
          end

          it "displays a flash alert" do
            do_request
            expect(flash[:alert]).to eq("You are not authorized to perform this action.")
          end
        end
      end

      context "when user is not a member of the organization" do
        it "returns http not found" do
          do_request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "DELETE /destroy" do
    let(:do_request) { delete "/organizations/#{organization.id}" }

    it_behaves_like "when user is not logged in"

    context "when user is logged in" do
      include_context "when user is logged in"

      context "when user is a member of the organization" do
        let(:membership) { create(:membership, user: user, organization: organization, role: role) }

        before do
          membership
        end

        context "when user is an owner of the organization" do
          let(:role) { :owner }

          it "destroys the requested organization" do
            organization
            expect {
              do_request
            }.to change(Organization, :count).by(-1)
          end

          it "redirects to the organizations list" do
            do_request
            expect(response).to redirect_to(organizations_url)
          end
        end

        context "when user is an admin of the organization" do
          let(:role) { :admin }

          it "redirects to the organization page" do
            do_request
            expect(response).to redirect_to(organization_path(organization))
          end

          it "displays a flash alert" do
            do_request
            expect(flash[:alert]).to eq("You are not authorized to perform this action.")
          end
        end

        context "when user is not an admin of the organization" do
          let(:role) { :member }

          it "redirects to the organization page" do
            do_request
            expect(response).to redirect_to(organization_path(organization))
          end

          it "displays a flash alert" do
            do_request
            expect(flash[:alert]).to eq("You are not authorized to perform this action.")
          end
        end
      end

      context "when user is not a member of the organization" do
        it "returns http not found" do
          do_request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
