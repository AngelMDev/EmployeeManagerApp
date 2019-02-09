FactoryBot.define do
  factory :department do
    name { "Marketing" }
    company_id { 1 }
    director_id { 2 }
    location { "Office 201" }
  end
end
