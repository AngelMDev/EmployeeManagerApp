FactoryBot.define do
  factory :employee do
    name { "John Doe" }
    department_id { 1 }
    admin { false }
    title { "Designer" }
    email { "john_doe@bloomberg.com" }
    address { "123 fake st " }
    phone { "123-4567" }
    salary { 50000 }
    bonus { 2500 }
    health_insurance { true }
    matching { true }
    pto { true }
  end

  factory :random_employee, class: 'Employee' do
    name { Faker::Name.name }
    department_id { 1 }
    admin { false }
    title { Faker::Job.title }
    email { Faker::Internet.email }
    address { Faker::Address.street_address }
    phone { Faker::PhoneNumber.phone_number }
    salary { 80000 }
    bonus { 3500 }
    health_insurance { true }
    matching { true }
    pto { true }
  end

  factory :admin, class: 'Employee' do
    name { "Rob Smith" }
    department_id { 1 }
    admin { true }
    title { "Director of Marketing" }
    email { "rob_smith@bloomberg.com" }
    address { "123 evergreen ave " }
    phone { "123-5555" }
    salary { 250000 }
    bonus { 25000 }
    health_insurance { true }
    matching { true }
    pto { true }
  end
end
