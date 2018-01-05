FactoryGirl.define do
  factory :template do
    type_of 0
    name {Faker::Name.name}
    template_body "index.html"
    association :user, factory: :user
  end
end
