require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    let(:do_request) { get root_path }

    it "returns http success" do
      do_request
      expect(response).to have_http_status(:success)
    end
  end
end
