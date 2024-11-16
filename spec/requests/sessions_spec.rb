require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user, password: 'password123') }

  before do
    user
  end

  describe "GET /new" do
    let(:do_request) { get new_session_path }

    describe "when user is not logged in" do
      it "returns http success" do
        do_request
        expect(response).to have_http_status(:success)
      end
    end

    describe "when user is logged in" do
      let(:session) { create(:session, user: user) }

      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "redirects to the root path" do
        do_request
        expect(response).to redirect_to(root_path)
      end

      it "displays a flash message" do
        do_request
        expect(flash[:alert]).to eq("You are already logged in.")
      end
    end
  end

  describe "POST /create" do
    let(:do_request) { post session_path, params: params }
    let(:params) {
      {
        email_address: user.email_address,
        password: 'password123'
      }
    }

    it "creates a new session" do
      expect { do_request }.to change { Session.count }.by(1)
    end

    it "redirects to the root path" do
      do_request
      expect(response).to redirect_to(root_path)
    end

    describe "when email address is invalid" do
      let(:params) {
        {
          email_address: 'wrong@example.com',
          password: 'password123'
        }
      }

      it "does not create a new session" do
        expect { do_request }.not_to change { Session.count }
      end

      it "redirects to the new session path" do
        do_request
        expect(response).to redirect_to(new_session_path)
      end
    end

    describe "when password is invalid" do
      let(:params) {
        {
          email_address: user.email_address,
          password: 'wrongpassword'
        }
      }

      it "does not create a new session" do
        expect { do_request }.not_to change { Session.count }
      end

      it "redirects to the new session path" do
        do_request
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
