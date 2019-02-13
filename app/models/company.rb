class Company < ApplicationRecord
  has_many :departments
  has_many :employees, through: :departments

  validates :company_name, presence: true, uniqueness: true

  def to_param
    company_name
  end

end
