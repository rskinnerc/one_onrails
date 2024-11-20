require 'rails_helper'

RSpec.describe "/addresses", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:valid_attributes) {
    {
      address: {
        address_line_1: "123 Main St",
        address_line_2: "Apt 1",
        country: "United States",
        city: "Anytown",
        state: "CA",
        postal_code: "12345"
      }
    }
  }

  describe "GET /index" do
    let(:do_request) { get addresses_url }
    let(:addresses) { create_list(:address, 3, user: user, default: false) }

    before do
      addresses
    end

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "renders a successful response" do
        do_request
        expect(response).to be_successful
      end

      it "renders a list of addresses" do
        do_request
        addresses.each do |address|
          expect(response.body).to include(address.address_line_1)
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET /show" do
    let(:do_request) { get address_url(address) }
    let(:address) { create(:address, user: user) }

    before do
      address
    end

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "renders a successful response" do
        do_request
        expect(response).to be_successful
      end

      it "renders the address" do
        do_request
        expect(response.body).to include(address.address_line_1)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET /new" do
    let(:do_request) { get new_address_url }

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "renders a successful response" do
        do_request
        expect(response).to be_successful
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET /edit" do
    let(:do_request) { get edit_address_url(address) }
    let(:address) { create(:address, user: user) }

    before do
      address
    end

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "renders a successful response" do
        do_request
        expect(response).to be_successful
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "POST /create" do
    let(:do_request) { post addresses_url, params: valid_attributes }

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      context "with valid parameters" do
        it "creates a new Address" do
          expect {
            do_request
          }.to change(Address, :count).by(1)
        end

        it "redirects to the created address" do
          do_request
          expect(response).to redirect_to(address_url(Address.last))
        end
      end

      context "when there is a default address" do
        let(:default_address) { create(:address, user: user) }

        before do
          default_address
          valid_attributes[:address][:default] = "1"
        end

        it "creates a new Address" do
          expect {
            do_request
          }.to change(Address, :count).by(1)
        end

        it "sets the new address as the default" do
          do_request
          expect(Address.last.default).to be(true)
        end

        it "sets the default address as non-default" do
          do_request
          expect(default_address.reload.default).to be(false)
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "PATCH /update" do
    let(:address) { create(:address, user: user, default: false) }
    let(:new_attributes) {
      {
        address: {
          address_line_1: "456 Main St"
        }
      }
    }
    let(:do_request) { patch address_url(address), params: new_attributes }

    before do
      address
    end

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "updates the requested address" do
        do_request
        address.reload
        expect(address.address_line_1).to eq("456 Main St")
      end

      it "redirects to the address" do
        do_request
        expect(response).to redirect_to(address_url(address))
      end

      context "when there is a default address" do
        let(:default_address) { create(:address, user: user, default: true) }

        before do
          default_address
          new_attributes[:address][:default] = "1"
        end

        it "updates the requested address" do
          do_request
          address.reload
          expect(address.address_line_1).to eq("456 Main St")
        end

        it "sets the new address as the default" do
          do_request
          expect(address.reload.default).to be(true)
        end

        it "sets the default address as non-default" do
          do_request
          expect(default_address.reload.default).to be(false)
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "DELETE /destroy" do
    let(:do_request) { delete address_url(address) }
    let(:address) { create(:address, user: user) }

    before do
      address
    end

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "destroys the requested address" do
        expect {
          do_request
        }.to change(Address, :count).by(-1)
      end

      it "redirects to the addresses list" do
        do_request
        expect(response).to redirect_to(addresses_url)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "PATCH /make_default" do
    let(:do_request) { patch make_default_address_url(address) }
    let(:address) { create(:address, user: user, default: false) }

    before do
      address
    end

    context "when user is logged in" do
      before do
        allow(Current).to receive(:session).and_return(session)
      end

      it "sets the requested address as the default" do
        do_request
        address.reload
        expect(address.default).to be(true)
      end

      context "when there is a default address" do
        let(:default_address) { create(:address, user: user, default: true) }

        before do
          default_address
        end

        it "sets the requested address as the default" do
          do_request
          address.reload
          expect(address.default).to be(true)
        end

        it "sets the default address as non-default" do
          do_request
          default_address.reload
          expect(default_address.default).to be(false)
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        do_request
        expect(response).to redirect_to(new_session_url)
      end
    end
  end
end
