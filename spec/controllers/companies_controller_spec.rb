require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  before(:each) do
    @company1 = create(:company)
    @company2 = create(:random_company)
    @department1 = create(:department, company_id: @company1.id)
    @employee1 = create(:employee, department_id: @department1.id)
  end

  context 'any user' do
    before(:each) do
      session[:user] = nil
    end

    it 'should be able to access the company index' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  context 'a logged in user' do
    before(:each) do
      session[:user] = @employee1.id
    end

    it 'should be able to access the company where they belong' do
      get :show, params: { name: @company1.company_name }
      expect(response).to redirect_to(company_employee_path(@company1.company_name, @employee1))
    end

    it 'should not be able to access a company where they don\'t belong' do
      get :show, params: { name: @company2.company_name }
      expect(response).to redirect_to(root_path)
      expect(controller).to set_flash[:alert]
    end
  end
end
