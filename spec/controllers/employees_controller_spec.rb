require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  before(:each) do
    @company = create(:company)
    @department = create(:department)
    @employee = create(:employee)
    @employee2 = create(:random_employee)
    @company2 = create(:random_company)
    @department2 = create(:random_department, company_id: @company2.id)
    @employee3 = create(:employee, department_id: @department2.id)
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
      patch :update_information, params: { company_name: @company.company_name, id: @employee.id, employee: { address: '890 Old Street' } }
      expect(controller).to set_flash[:success]
      expect(response).to redirect_to(company_employee_path(@company.company_name, @employee))
      @employee.reload
      expect(@employee.address).to eq('890 Old Street')
    end

    it 'should not have access to employee index' do
      get :index, params: { company_name: @company.company_name }
      expect(response).to redirect_to(company_employee_path(@company.company_name, @employee))
      expect(controller).to set_flash[:alert]
    end

    it 'should not have access to view other employee information' do
      get :show, params: { company_name: @company.company_name, id: @employee2.id }
      expect(response).to redirect_to(root_path)
      expect(controller).to set_flash[:alert]
    end

    it 'should not be able to edit compensation information' do
      get :edit_compensation, params: { company_name: @company.company_name, id: @employee.id }
      expect(response).to redirect_to(company_employee_path(@company.company_name, @employee))
      expect(controller).to set_flash[:alert]
    end

    it 'should not be able to update compensation information' do
      patch :update_compensation, params: { company_name: @company.company_name, id: @employee.id, employee: { salary: 100000 } }
      expect(response).to redirect_to(company_employee_path(@company.company_name, @employee))
      @employee.reload
      expect(@employee.salary).not_to eq(100000)
      expect(controller).to set_flash[:alert]
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

    it 'should update personal information successfully with valid data' do
      put :update_information, params: { company_name: @company.company_name, id: @employee.id, employee: { address: '890 Old Street' } }
      expect(controller).to set_flash[:success]
      @employee.reload
      expect(response).to redirect_to(company_employee_path(@company.company_name, @employee))
      expect(@employee.address).to eq('890 Old Street')
    end

    it 'should update compensation information successfully with valid data' do
      put :update_compensation, params: { company_name: @company.company_name, id: @employee.id, employee: { salary: 100000 } }
      expect(controller).to set_flash[:success]
      @employee.reload
      expect(response).to redirect_to(company_employee_path(@company.company_name, @employee))
      expect(@employee.salary).to eq(100000)
    end

    it 'should NOT update personal information successfully with invalid data' do
      put :update_information, params: { company_name: @company.company_name, id: @employee.id, employee: { email: nil } }
      expect(controller).to set_flash[:alert]
      @employee.reload
      expect(response).to redirect_to(edit_information_company_employee_path(@company.company_name, @employee))
      expect(@employee.email).to eq('john_doe@bloomberg.com')
    end

    it 'should NOT update compensation information successfully with invalid data' do
      put :update_compensation, params: { company_name: @company.company_name, id: @employee.id, employee: { salary: nil } }
      expect(controller).to set_flash[:alert]
      @employee.reload
      expect(response).to redirect_to(edit_compensation_company_employee_path(@company.company_name, @employee))
      expect(@employee.salary).to eq(50000)
    end

    it 'should NOT have access to an employee from another company' do
      get :show, params: { company_name: @company2.company_name, id: @employee3.id }
      expect(response).to have_http_status(302)
      expect(controller).to set_flash[:alert]
    end

    it 'should NOT be able to update information of an employee from another company' do
      salary = @employee3.salary
      put :update_compensation, params: { company_name: @company2.company_name, id: @employee3.id, employee: { salary: 500000 } }
      expect(response).to have_http_status(302)
      expect(controller).to set_flash[:alert]
      @employee3.reload
      expect(@employee3.salary).to eq(salary)
    end
  end
end
