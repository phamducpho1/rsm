require "rails_helper"

RSpec.describe Employers::TemplatesController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  let(:template) {FactoryGirl.create :template}
  subject {template}
  before {sign_in FactoryGirl.create :user}

  describe "GET /employers/templates" do
    it "returns http success for an AJAX request" do
      {:get => "/employers/templates", format: :xhr}.should be_routable
    end
  end

  describe "GET /employers/templates/new" do
    it "returns http success for an AJAX request" do
      {:get => "/employers/templates/new", format: :xhr}.should be_routable
    end
  end

  describe "POST #create" do
    it "create template success" do
      post :create, params: {template: {name: "phamd1ucpho", type_of: "template_member",
        template_body: "index.html", user_id: user.id}},
        xhr: true, format: "js"
      expect(response).to be_success
    end
    it "create template fail" do
      post :create, params: {template: {name: "phamd1ucpho", type_of: 2312312,
        template_body: "index.html", user_id: 11313}},
        xhr: true, format: "js"
    end
  end

  describe "GET #show" do
    before :each do
      get :show, format: :xhr, params: {id: subject.id}
    end
    it "assigns the requested user to @template" do
      expect(assigns(:template)) == template
    end
  end
end
