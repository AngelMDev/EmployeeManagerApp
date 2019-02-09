class Company < ApplicationRecord
  has_many :departments
  validates :name, presence: true
end
