require 'rails_helper'

RSpec.describe "Flipper UI", type: :request do
  let(:super_admin) { create(:user, :super_admin, email_address: 'admin@example.com', password: 'password') }
  let(:non_admin) { create(:user, email_address: 'user@example.com', password: 'password') }

  describe "GET /flipper" do
    let(:do_request) { get "/flipper", headers: headers }
    let(:headers) { {} }

    context "with valid super admin credentials" do
      let(:headers) { { "HTTP_AUTHORIZATION" => basic_auth(super_admin.email_address, 'password') } }

      it "allows access to the Flipper UI" do
        do_request
        expect(response).to redirect_to("/flipper/features")
      end
    end

    context "with invalid credentials" do
      let(:headers) { { "HTTP_AUTHORIZATION" => basic_auth(super_admin.email_address, 'wrong_password') } }

      it "denies access to the Flipper UI" do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with no credentials" do
      it "denies access to the Flipper UI" do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  def basic_auth(username, password)
    ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end
end
