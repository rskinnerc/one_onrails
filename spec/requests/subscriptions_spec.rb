require 'rails_helper'

RSpec.describe "/subscriptions", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  describe "GET /" do
    let(:do_request) { get "/account/subscription" }


    context "when user is not logged in" do
      it "redirects to the login page" do
        do_request
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "returns http success" do
        do_request
        expect(response).to have_http_status(:success)
      end
    end
  end
end
