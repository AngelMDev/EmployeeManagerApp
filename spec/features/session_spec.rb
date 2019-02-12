require 'rails_helper.rb'

feature 'Sign in' do
  let!(:company) { create(:company) }
  let!(:department) { create(:department) }
  let!(:employee) { create(:employee) }
  let!(:admin) { create(:admin) }

  before(:each) do
    visit '/'
  end

  scenario 'as an employee' do
    select('John Doe', :from => 'employee')
    click_button 'Sign in'
    expect(page).to have_content('(Employee)').and have_content('John Doe')
  end

  scenario 'as an admin' do
    select('Rob Smith', :from => 'employee')
    click_button 'Sign in'
    expect(page).to have_content('(Admin)').and have_content('Rob Smith')
  end
end