require "rails_helper"

RSpec.describe Offer, type: :model do
  context "associations" do
    it {should belong_to :user}
    it {should belong_to :apply_status}
  end

  context "columns" do
    it {should have_db_column(:salary).of_type(:float)}
    it {should have_db_column(:start_time).of_type(:date)}
    it {should have_db_column(:address).of_type(:text)}
  end
end
