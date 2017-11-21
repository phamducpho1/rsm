require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  subject {user}

  describe "GET #show" do
    before{get :show, params: {id: subject.id}}
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end

end
