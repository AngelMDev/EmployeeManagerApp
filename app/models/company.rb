class Company < ApplicationRecord
  has_many :departments
  has_many :employees, through: :departments

  validates :company_name, presence: true, uniqueness: true

  def to_param
    company_name
  end

  def top_three_earners_by_department
    sql = <<-SQL
      SELECT id, name, salary, department_id, department_name, company_id
      FROM (
        SELECT employees.id id, name, department_id, department_name, salary, company_id, RANK() 
          OVER (PARTITION BY department_id 
                ORDER BY department_name, salary DESC) 
          AS rank 
        FROM employees 
        INNER JOIN departments ON employees.department_id = departments.id 
        INNER JOIN companies ON companies.id = departments.company_id 
        WHERE company_id = #{id}) 
      WHERE rank <= 3
    SQL
    Employee.find_by_sql(sql)
  end

end
