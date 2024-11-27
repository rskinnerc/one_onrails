require 'rails_helper'

RSpec.shared_examples "when registrations flag is disabled" do
  before do
    Flipper.enable(:registrations)
  end

  it "redirects to the root path" do
    do_request
    expect(response).to redirect_to(root_path)
  end

  it "displays a alert flash message" do
    do_request
    expect(flash[:alert]).to eq("Registrations are currently disabled.")
  end
end

RSpec.describe "Registrations", type: :request do
  let(:user) { create(:user) }

  before do
    user
    Flipper.enable(:registrations)
  end

  describe "GET /new" do
    let(:do_request) { get new_registration_path }

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
    let(:do_request) { post registrations_path, params: params }
    let(:params) {
      {
        email_address: Faker::Internet.email,
        password: 'password123',
        password_confirmation: 'password123'
      }
    }

    before do
      allow(Users::CreateInitialSubscription).to receive(:call).and_call_original
    end

    it "creates a new user" do
      expect { do_request }.to change { User.count }.by(1)
    end

    it "calls the CreateInitialSubscription service" do
      expect(Users::CreateInitialSubscription).to receive(:call)
      do_request
    end

    it "creates a new session" do
      expect { do_request }.to change { Session.count }.by(1)
    end

    it "redirects to the root path" do
      do_request
      expect(response).to redirect_to(root_path)
    end

    describe "with invalid params" do
      let(:params) {
        {
          email_address: Faker::Internet.email,
          password: 'password123',
          password_confirmation: 'password'
        }
      }

      it "does not call the CreateInitialSubscription service" do
        expect(Users::CreateInitialSubscription).not_to receive(:call)
        do_request
      end

      it "does not create a new user" do
        expect { do_request }.not_to change { User.count }
      end

      it "does not create a new session" do
        expect { do_request }.not_to change { Session.count }
      end

      it "returns http unprocessable entity" do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
