FactoryBot.define do
  factory :company do
    company_name { "Bloomberg" }
    sector { "Financial" }
    address { "123 Main ave" }
    phone { "555-5555" }
  end

  factory :random_company, class: 'Company' do
    company_name { Faker::Company.name }
    sector { Faker::Company.industry }
    address { Faker::Address.street_address }
    phone { Faker::PhoneNumber.phone_number }
  end
end
