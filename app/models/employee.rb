class Employee < ApplicationRecord
  belongs_to :department

  validates :name, :title, :email, :salary, presence: true

  def company
    department.company
  end

  # We use this to populate the sign in select box.
  def name_company_role
    "#{name} - #{company.company_name} #{' (Administrator) ' if admin? }"
  end
end
