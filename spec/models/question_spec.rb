require "rails_helper"

RSpec.describe Question, type: :model do
  context "associations" do
    it {is_expected.to have_many :answers}
    it {is_expected.to belong_to :job}
  end

  context "validates" do
    it {is_expected.to validate_presence_of :name}
  end

  context "attributes" do
    it {is_expected.to accept_nested_attributes_for(:answers).allow_destroy true}
  end

  context "columns" do
    it {is_expected.to have_db_column(:job_id).of_type :integer}
    it {is_expected.to have_db_column(:name).of_type :text}
  end
end
