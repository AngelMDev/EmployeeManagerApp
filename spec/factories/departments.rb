FactoryBot.define do
  factory :department do
    department_name { "Marketing" }
    company_id { 1 }
    location { "Office 201" }
  end

  factory :random_department do
    department_name { Faker::Job.field }
    company_id { 1 }
    location { Faker::Address.secondary_address }
  end
end
