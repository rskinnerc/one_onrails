RSpec.shared_context "when user is logged in" do
  before do
    allow(Current).to receive(:session).and_return(session)
  end
end
