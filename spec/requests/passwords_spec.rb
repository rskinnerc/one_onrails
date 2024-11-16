require 'rails_helper'

RSpec.shared_examples "an authenticated user" do
  describe "when the user is logged in" do
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

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user, password: 'password123') }

  before do
    user
  end

  describe "GET /new" do
    let(:do_request) { get new_password_path }

    it_behaves_like "an authenticated user"

    describe "when the user is not logged in" do
      it "returns http success" do
        do_request
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /create" do
    let(:do_request) { post passwords_path, params: params }
    let(:params) { { email_address: user.email_address } }

    it "sends a password reset email" do
      expect { do_request }.to have_enqueued_mail(PasswordsMailer, :reset)
    end

    it "redirects to the new session path" do
      do_request
      expect(response).to redirect_to(new_session_path)
    end

    it "displays a flash message" do
      do_request
      expect(flash[:notice]).to eq("Password reset instructions sent (if user with that email address exists).")
    end
  end

  describe "GET /edit" do
    let(:do_request) { get edit_password_path(token) }
    let(:token) { user.password_reset_token }

    it_behaves_like "an authenticated user"

    describe "when the user is not logged in" do
      it "returns http success" do
        do_request
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PUT /update" do
    let(:do_request) { put password_path(token), params: params }
    let(:token) { user.password_reset_token }
    let(:params) { { password: 'newpassword', password_confirmation: 'newpassword' } }

    it "updates the user's password" do
      do_request
      expect(user.reload.authenticate('newpassword')).to eq(user)
    end

    it "redirects to the new session path" do
      do_request
      expect(response).to redirect_to(new_session_path)
    end

    it "displays a flash message" do
      do_request
      expect(flash[:notice]).to eq("Password has been reset.")
    end

    describe "when the passwords do not match" do
      let(:params) { { password: 'newpassword', password_confirmation: 'wrongpassword' } }

      it "redirects to the edit password path" do
        do_request
        expect(response).to redirect_to(edit_password_path(token))
      end

      it "displays a flash message" do
        do_request
        expect(flash[:alert]).to eq("Passwords did not match.")
      end
    end

    describe "when the token is invalid" do
      let(:token) { 'invalidtoken' }

      it "redirects to the new password path" do
        do_request
        expect(response).to redirect_to(new_password_path)
      end

      it "displays a flash message" do
        do_request
        expect(flash[:alert]).to eq("Password reset link is invalid or has expired.")
      end
    end
  end
end
