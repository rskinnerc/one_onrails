require 'rails_helper'

RSpec.describe "/account/profile", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:valid_attributes) {
    {
      profile: {
        first_name: "John",
        last_name: "Doe",
        phone: "+13208888616",
        country: "US"
      }
    }
  }

  let(:invalid_attributes) {
    {
      profile: {
        first_name: nil,
        last_name: nil,
        phone: nil,
        country: nil
      }
    }
  }

  describe "GET /" do
    let(:do_request) { get profile_url }

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
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET /new" do
    let(:do_request) { get new_profile_url }

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
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET /edit" do
    let(:do_request) { get edit_profile_url }

    context "when user is signed in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      context "when user has a profile" do
        let!(:profile) { create(:profile, user: user) }

        it "renders a successful response" do
          do_request
          expect(response).to be_successful
        end
      end

      context "when user does not have a profile" do
        it "redirects to the profile page" do
          do_request
          expect(response).to redirect_to(profile_url)
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

  describe "POST /create" do
    let(:do_request) { post profile_url, params: params }

    context "when user is signed in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      context "with valid parameters" do
        let(:params) { valid_attributes }

        it "creates a new Profile" do
          expect {
            do_request
          }.to change(Profile, :count).by(1)
        end

        it "redirects to the created profile" do
          do_request
          expect(response).to redirect_to(profile_url)
        end
      end

      context "with invalid parameters" do
        let(:params) { invalid_attributes }

        it "does not create a new Profile" do
          expect {
            do_request
          }.to change(Profile, :count).by(0)
        end

        it "renders a successful response (i.e. to display the 'new' template)" do
          do_request
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is not signed in" do
      let(:params) { valid_attributes }

      it "redirects to the sign in page" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "PATCH /update" do
    let(:do_request) { patch profile_url, params: params }

    context "when user is signed in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      context "with valid parameters" do
        let!(:profile) { create(:profile, user: user) }
        let(:params) { valid_attributes }

        it "updates the requested profile" do
          do_request
          profile.reload
          expect(profile.first_name).to eq("John")
          expect(profile.last_name).to eq("Doe")
          expect(profile.phone).to eq("+13208888616")
          expect(profile.country).to eq("US")
        end

        it "redirects to the profile" do
          do_request
          expect(response).to redirect_to(profile_url)
        end

        context "when the user has an avatar" do
          let!(:profile) { create(:profile, :with_avatar, user: user) }

          context "when remove_avatar is set to 1" do
            let(:params) { valid_attributes.merge(profile: { remove_avatar: "1" }) }

            it "removes the avatar" do
              do_request
              profile.reload
              expect(profile.avatar.attached?).to be_falsey
            end
          end
        end

        context "when the request includes an avatar" do
          let(:avatar) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg'), 'image/jpeg') }
          let(:params) { valid_attributes.merge(profile: { avatar: avatar }) }

          it "updates the avatar" do
            do_request
            profile.reload
            expect(profile.avatar.attached?).to be_truthy
          end
        end
      end

      context "with invalid parameters" do
        let!(:profile) { create(:profile, user: user) }
        let(:params) { invalid_attributes }

        it "renders a successful response (i.e. to display the 'edit' template)" do
          do_request
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is not signed in" do
      let(:params) { valid_attributes }

      it "redirects to the sign in page" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "DELETE /destroy" do
    let(:do_request) { delete profile_url }

    context "when user is signed in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      context "when user has a profile" do
        let!(:profile) { create(:profile, user: user) }

        it "destroys the requested profile" do
          expect {
            do_request
          }.to change(Profile, :count).by(-1)
        end

        it "redirects to the profile" do
          do_request
          expect(response).to redirect_to(profile_url)
        end
      end

      context "when user does not have a profile" do
        it "redirects to the profile page" do
          do_request
          expect(response).to redirect_to(profile_url)
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
