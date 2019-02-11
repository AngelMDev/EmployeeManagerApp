class Company < ApplicationRecord
  has_many :departments
  validates :company_name, presence: true, uniqueness: true


end
