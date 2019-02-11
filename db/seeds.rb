# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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