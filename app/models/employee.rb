class Employee < ApplicationRecord
  belongs_to :department

  validates :name, :title, :email, :salary, presence: true

  # Find the top earners of a company sorted by department name and salary
  scope :top_earners_for_company, ->(company) {
    company.employees
           .select(:id, :name, :department_name, :salary)
           .order('department_name', salary: :desc)
  }

  def company
    department.company
  end

  # We use this to populate the sign in select box.
  def name_company_role
    "#{name} - #{company.company_name} #{' (Administrator) ' if admin? }"
  end

  def self.top_earners_by_department(company)
    Employee.top_earners_for_company(company) # Gets sorted list of employees, their salaries and departments
            .group_by { |t| t.department_name } # Generates a hash where the key is the department name and the value the employees of that department
            .values.map { |group| group.take(3) } # Selects only 3 employees from each group
            .flatten # Flattens into a single array
  end
end
