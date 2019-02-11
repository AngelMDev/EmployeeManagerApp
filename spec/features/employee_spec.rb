require 'rails_helper.rb'

feature 'View employee information' do
  let!(:company) { create(:company) }
  let!(:department) { create(:department) }
  let!(:employee) { create(:employee) }
  let!(:admin) { create(:admin) }

  before(:each) do
    visit '/bloomberg'
  end

  scenario 'of an employee' do
    select(employee.name, :from => 'employee')
    click_button 'Sign in'
    expect(page).to have_content(employee.email).and have_content(employee.name).and have_content(employee.salary)
  end

  scenario 'of another employee as an administrator' do
    select('Rob Smith', :from => 'employee')
    click_button 'Sign in'
    click_link 'View all employees'
    click_link employee.name
    expect(page).to have_content(employee.email).and have_content(employee.name).and have_content(employee.salary)
  end
end

feature 'Edit personal information' do
  before(:each) do
    visit '/bloomberg'
  end

  scenario 'of an employee as an employee' do
    select(employee.name, :from => 'employee')
    click_button 'Sign in'
    click_link 'Edit personal information'
    fill_in 'email', with: 'john_doe2@bloomberg.com'
    fill_in 'address', with: '123 New Avenue Apt 201'
    fill_in 'phone', with: '888-8888'
    click_button 'Save'
    expect(page).to have_content('john_doe2@bloomberg.com').and have_content('123 New Avenue Apt 201').and have_content('888-8888')
  end

  scenario 'of another employee as an administrator' do
    select(admin.name, :from => 'employee')
    click_button 'Sign in'
    click_link 'View all employees'
    click_link employee.name
    click_link 'Edit personal information'
    fill_in 'email', with: 'john_doe3@bloomberg.com'
    fill_in 'address', with: '256 Old Avenue Apt 201'
    fill_in 'phone', with: '333-3333'
    click_button 'Save'
    expect(page).to have_content('john_doe3@bloomberg.com').and have_content('256 Old Avenue Apt 201').and have_content('333-3333')
  end
end

feature 'Edit compensation information' do
  before(:each) do
    visit '/bloomberg'
  end

  scenario 'of another employee as an administrator' do
    select(admin.name, :from => 'employee')
    click_button 'Sign in'
    click_link 'View all employees'
    click_link employee.name
    click_link 'Edit compensation information'
    fill_in 'salary', with: '75000'
    fill_in 'bonus', with: '5000'
    click_button 'Save'
    expect(page).to have_content('75000').and have_content('5000')
  end

  scenario 'as an employee to not have access to this feature' do
    select(employee.name, :from => 'employee')
    click_button 'Sign in'
    expect(page).not_to have_content('Edit compensation information')
  end
end


