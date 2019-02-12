require 'rails_helper'

RSpec.describe Department, type: :model do
  let!(:company) { create(:company) }

  it "is valid with valid attributes" do
    department = build(:department)
    expect(department).to be_valid
  end

  it { should have_many(:employees) }
  it { should belong_to(:company) }
  it { should validate_presence_of(:department_name) }
end
