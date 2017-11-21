require "rails_helper"
RSpec.describe "users/show.html.erb", type: :view do
  let(:user) {FactoryGirl.create(:user)}
  subject {user}

  it "displays user details" do
    assign(:user, subject)
    render
    expect(subject).to render_template("users/show")
    expect(rendered).to include(user.name)
    expect(rendered).to include(user.email)
    expect(rendered).to include(user.phone)
    expect(rendered).to include(user.address)
  end
end
