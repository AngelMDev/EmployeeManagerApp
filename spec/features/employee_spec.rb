require 'rails_helper.rb'

feature 'View employee information' do
  let!(:company) { create(:company) }
  let!(:department) { create(:department) }
  let!(:employee) { create(:employee) }
  let!(:admin) { create(:admin) }

  scenario 'of an employee as an employee' do
    visit '/bloomberg'
    select('John Doe', :from => 'Sign in as')
    click_button 'Sign in'
    expect(page).to have_content('john_doe@bloomberg.com').and have_content('John Doe').and have_content('50000')
  end

  scenario 'of another employee as an administrator' do
    visit '/bloomberg'
    select('Rob Smith', :from => 'Sign in as')
    click_button 'Sign in'
    click_link 'View all employees'
    click_link 'John Doe'
    expect(page).to have_content('john_doe@bloomberg.com').and have_content('John Doe').and have_content('50000')
  end
end

feature 'Edit personal information' do
  scenario 'of an employee as an employee' do
    visit '/bloomberg'
    select('John Doe', :from => 'Sign in as')
    click_button 'Sign in'
    click_link 'Edit personal information'
    fill_in 'email', with: 'john_doe2@bloomberg.com'
    fill_in 'address', with: '123 New Avenue Apt 201'
    fill_in 'phone', with: '888-8888'
    click_button 'Save'
    expect(page).to have_content('john_doe2@bloomberg.com').and have_content('123 New Avenue Apt 201').and have_content('888-8888')
  end

  scenario 'of another employee as an administrator' do
    visit '/bloomberg'
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

feature 'Edit compensation information' do
  scenario 'of another employee as an administrator' do
    visit '/bloomberg'
    select('Rob Smith', :from => 'Sign in as')
    click_button 'Sign in'
    click_link 'View all employees'
    click_link 'John Doe'
    click_link 'Edit compensation information'
    fill_in 'salary', with: '75000'
    fill_in 'bonus', with: '5000'
    click_button 'Save'
    expect(page).to have_content('75000').and have_content('5000')
  end
end


