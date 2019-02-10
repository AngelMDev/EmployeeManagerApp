require 'rails_helper.rb'

feature 'View company information' do
  let!(:company) { create(:company) }
  let!(:department) { create(:department) }
  let!(:employee) { create(:employee) }
  let!(:admin) { create(:admin) }

  scenario 'as an administrator' do
    visit '/'
    click_link 'Bloomberg'
    select('Rob Smith', :from => 'Sign in as')
    click_button 'Sign in'
    click_link 'View all employees'
    click_link 'John Doe'
    click_link 'Edit personal information'
    fill_in 'email', with: 'john_doe3@bloomberg.com'
    fill_in 'address', with: '256 Old Avenue Apt 201'
    fill_in 'phone', with: '333-3333'
    click_button 'Save'
    expect(page).to have_content('john_doe3@bloomberg.com').and have_content('256 Old Avenue Apt 201').and have_content('333-3333')
  end
end