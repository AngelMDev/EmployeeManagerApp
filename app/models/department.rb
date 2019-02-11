class Department < ApplicationRecord
  has_many :employees
  belongs_to :company

  validates :department_name, presence: true
end
