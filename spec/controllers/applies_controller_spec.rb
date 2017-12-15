require "rails_helper"

RSpec.describe AppliesController, type: :controller do

  let(:job) {FactoryGirl.create :job}

  let(:user) {FactoryGirl.create :user}

  describe "POST #create" do
    it "apply success" do

      post :create, params: {apply:{status: 0, user_id: user.id, job_id: job.id, cv: "1.pdf", information:{"name"=>"Herman Morar IV",
        "email"=>"employer1@gmail.com", "phone"=>"096560364", "introducing"=>"31231231"}}},
        xhr: true, format: "js"
      expect(flash.now[:success] = I18n.t("apply.applied"))
    end

    it "apply fail" do
      post :create, params: {apply:{status: 0, user_id: user.id, job_id: 140} },
        xhr: true, format: "js"
    end
  end
end
