require "rails_helper"

RSpec.describe Question, type: :model do

  context "associations" do
    it {should have_many :answers}
    it {should belong_to :job}
  end

  context "validates" do
    it {is_expected.to validate_presence_of(:name)}
  end
end
