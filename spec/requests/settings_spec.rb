require 'rails_helper'

RSpec.describe "/account/settings", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:valid_attributes) {
    {
      setting: {
        theme: "night"
      }
    }
  }

  describe "GET /" do
    let(:do_request) { get settings_url }
    context "when user is signed in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      context "when user has a setting" do
        let!(:setting) { create(:user_setting, user: user) }

        it "renders a successful response" do
          do_request
          expect(response).to be_successful
        end
      end

      context "when user does not have a setting" do
        it "redirects to the edit page" do
          do_request
          expect(response).to redirect_to(edit_settings_url)
        end
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign in page" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET /edit" do
    let(:do_request) { get edit_settings_url }
    context "when user is signed in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "renders a successful response" do
        do_request
        expect(response).to be_successful
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign in page" do
        get edit_settings_url
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "PATCH /update" do
    let(:do_request) { patch settings_url, params: valid_attributes }
    context "when user is signed in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      context "when the user has a setting" do
        let!(:setting) { create(:user_setting, user: user, theme: 0) }

        it "updates the setting" do
          do_request
          setting.reload
          expect(setting.theme).to eq("night")
        end

        it "redirects to the settings page" do
          do_request
          expect(response).to redirect_to(settings_url)
        end
      end

      context "when the user does not have a setting" do
        it "creates a new setting" do
          expect {
            do_request
          }.to change(User::Setting, :count).by(1)
        end

        it "redirects to the settings page" do
          do_request
          expect(response).to redirect_to(settings_url)
        end
      end
    end

    context "when user is not signed in" do
      it "redirects to the sign in page" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end
end
