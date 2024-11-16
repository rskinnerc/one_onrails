require 'rails_helper'

RSpec.describe "profiles/edit", type: :view do
  let(:profile) {
    Profile.create!(
      first_name: "MyString",
      last_name: "MyString",
      phone: "MyString",
      avatar: nil,
      country: "MyString",
      user: nil
    )
  }

  before(:each) do
    assign(:profile, profile)
  end

  it "renders the edit profile form" do
    render

    assert_select "form[action=?][method=?]", profile_path(profile), "post" do

      assert_select "input[name=?]", "profile[first_name]"

      assert_select "input[name=?]", "profile[last_name]"

      assert_select "input[name=?]", "profile[phone]"

      assert_select "input[name=?]", "profile[avatar]"

      assert_select "input[name=?]", "profile[country]"

      assert_select "input[name=?]", "profile[user_id]"
    end
  end
end
