
require 'faker'

Employee.destroy_all
Department.destroy_all
Company.destroy_all

company = Company.create(company_name: 'Bloomberg', sector: 'Finance', address: '123 Main ave', phone: '555-5555')
department = Department.create(department_name: 'Marketing', location: 'Office 201', company_id: company.id)
Employee.create(name: 'John Doe', admin: false, title: 'Designer',
                           email: 'john_doe@bloomberg.com', phone: '123-4567',
                           address: '123 fake st', salary: 50000, bonus: 5000,
                           health_insurance: true, matching: true, pto: true,
                           department_id: department.id)

Employee.create(name: 'Rob Smith', admin: true, title: 'Director of Marketing',
                email: 'rob_smith@bloomberg.com', phone: '123-4567',
                address: '123 evergreen ave', salary: 250000, bonus: 25000,
                health_insurance: true, matching: true, pto: true,
                department_id: department.id)

3.times do
  c = Company.create(company_name: Faker::Company.name.gsub(' ','_'),
                    sector: Faker::Company.industry,
                    address: Faker::Address.street_address,
                    phone: Faker::PhoneNumber.phone_number)
  5.times do
    d = Department.create(department_name: Faker::Job.field,
                          company_id: c.id,
                          location: Faker::Address.secondary_address)
    3.times do
      Employee.create(name: Faker::Name.name,
                      department_id: d.id,
                      admin: false,
                      title: Faker::Job.title,
                      email: Faker::Internet.email,
                      address: Faker::Address.street_address,
                      phone: Faker::PhoneNumber.phone_number,
                      salary: Faker::Number.between(30000, 150000),
                      bonus: Faker::Number.between(500, 9000),
                      health_insurance: true,
                      matching: true,
                      pto: true)
    end
  end
  Employee.create(name: Faker::Name.name,
                  department_id: c.departments.first.id,
                  admin: true,
                  title: Faker::Job.title,
                  email: Faker::Internet.email,
                  address: Faker::Address.street_address,
                  phone: Faker::PhoneNumber.phone_number,
                  salary: 120000,
                  bonus: 10500,
                  health_insurance: true,
                  matching: true,
                  pto: true)
end
