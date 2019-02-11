FactoryBot.define do
  factory :department do
    name { "Marketing" }
    company_id { 1 }
    location { "Office 201" }
  end

  factory :random_department do
    name { Faker::Job.field }
    company_id { 1 }
    location { Faker::Address.secondary_address }
  end
end
