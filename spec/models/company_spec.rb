require 'rails_helper'

RSpec.describe Company, type: :model do

  it "is valid with valid attributes" do
    company = build(:company)
    expect(company).to be_valid
  end

  it { should have_many(:departments) }
  it { should validate_presence_of (:company_name) }
end
