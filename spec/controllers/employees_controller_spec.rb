require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  before(:each) do
    @company = create(:company)
    @department = create(:department)
    @employee = create(:employee)
    @employee2 = create(:random_employee)
    @admin = create(:admin)
  end

  context 'not signed in user' do
    before(:each) do
      session[:user] = nil
    end

    it 'should not have access to employee index' do
      get :index, params: { company_name: @company.company_name }
      expect(response).to redirect_to(root_path)
      expect(controller).to set_flash[:alert]
    end

    it 'should not have access to view employee information' do
      get :show, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to redirect_to(root_path)
      expect(controller).to set_flash[:alert]
    end

    it 'should not have access to edit personal employee information' do
      get :edit_information, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to redirect_to(root_path)
      expect(controller).to set_flash[:alert]
    end

    it 'should not have access to edit employee compensation' do
      get :edit_compensation, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to redirect_to(root_path)
      expect(controller).to set_flash[:alert]
    end
  end

  context 'signed in employee' do
    before(:each) do
      session[:user] = @employee.id
    end

    it 'should have access to view their own information' do
      get :show, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to have_http_status(200)
    end

    it 'should have access to edit their own personal information' do
      get :edit_information, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to have_http_status(200)
    end

    it 'should update personal information successfully' do
      put :update_information, params: { company_name: @company.company_name, id: @employee.id, employee: { address: '890 Old Street' } }
      expect(controller).to set_flash[:success]
      expect(response).to redirect_to(@employee)
      expect(employee.address).to eq('890 Old Street')
    end

    it 'should not have access to employee index' do
      get :index, params: { company_name: @company.company_name }
      expect(response).to redirect_to(root_path)
      expect(controller).to set_flash[:alert]
    end

    it 'should not have access to view other employee information' do
      get :show, params: { company_name: @company.company_name, id: @employee2.id }
      expect(response).to redirect_to(root_path)
      expect(controller).to set_flash[:alert]
    end

    it 'should not be able to edit compensation information' do
      get :edit_compensation, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to redirect_to(@company)
      expect(controller).to set_flash[:alert]
    end

    it 'should not be able to update compensation information' do
      put :update_compensation, params: { company_name: @company.company_name, id: @employee.id, employee: { salary: 100000 } }
      expect(response).to redirect_to(@company)
      expect(@employee.salary).not_to eq(100000)
      expect(controller).to set_flash[:error]
    end
  end

  context 'signed in administrator' do
    before(:each) do
      session[:user] = @admin.id
    end

    it 'should have access to user index' do
      get :index, params: { company_name: @company.company_name }
      expect(response).to have_http_status(200)
    end

    it 'should have access to another user information' do
      get :show, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to have_http_status(200)
    end

    it 'should have access to edit another user personal information' do
      get :edit_information, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to have_http_status(200)
    end

    it 'should have access to edit another user compensation information' do
      get :edit_compensation, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to have_http_status(200)
    end

    it 'should update personal information successfully' do
      put :update_information, params: { company_name: @company.company_name, id: @employee.id, employee: { address: '890 Old Street' } }
      expect(controller).to set_flash[:success]
      expect(response).to redirect_to(@employee)
      expect(employee.address).to eq('890 Old Street')
    end

    it 'should update compensation information successfully' do
      put :update_compensation, params: { company_name: @company.company_name, id: @employee.id, employee: { salary: 100000 } }
      expect(controller).to set_flash[:success]
      expect(response).to redirect_to(@employee)
      expect(@employee.salary).to eq(100000)
    end
  end
end
