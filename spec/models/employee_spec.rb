require 'rails_helper'

RSpec.describe Employee, type: :model do
  let!(:company) { create(:company) }
  let!(:department) { create(:department) }

  it "is valid with valid attributes" do
    employee = build(:employee)
    expect(employee).to be_valid
  end

  it { should belong_to(:department) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:salary) }
end
