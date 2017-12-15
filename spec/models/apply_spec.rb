require "rails_helper"

RSpec.describe Apply, type: :model do

  context "associations" do
    it {should belong_to :user}
    it {should belong_to :job}
    it {should have_one :company}
  end
   context "columns" do
    it {should have_db_column(:status).of_type(:integer)}
    it {should have_db_column(:user_id).of_type(:integer)}
    it {should have_db_column(:job_id).of_type(:integer)}
    it {should have_db_column(:cv).of_type(:text)}
    it {should have_db_column(:information).of_type(:text)}
  end
end
