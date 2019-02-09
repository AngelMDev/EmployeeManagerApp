class Department < ApplicationRecord
  has_many :employees
  belongs_to :company

  validates :name, presence: true
end
