class Employee < ApplicationRecord
  belongs_to :department

  validates :name, :title, :email, :salary, presence: true
end
