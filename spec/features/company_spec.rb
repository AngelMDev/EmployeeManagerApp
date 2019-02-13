require 'rails_helper.rb'

feature 'View company information' do
  let!(:company) { create(:company) }
  let!(:department) { create(:department) }
  let!(:employee) { create(:employee) }
  let!(:admin) { create(:admin) }

  scenario 'as an administrator' do
    visit '/'
    select('Rob Smith', :from => 'employee')
    click_button 'Sign in'
    expect(page).to have_content(company.company_name).and have_content(company.address).and have_content(company.phone)
  end

  scenario 'as an employee to not have access to this feature' do
    visit '/'
    select(employee.name, :from => 'employee')
    click_button 'Sign in'
    visit '/Bloomberg'
    expect(page).not_to have_content('View all employees')
  end
end