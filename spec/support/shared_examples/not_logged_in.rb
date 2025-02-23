RSpec.shared_examples "when user is not logged in" do
  it "redirects to the login page" do
    do_request
    expect(response).to redirect_to(new_session_path)
  end
end
