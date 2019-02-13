class EmployeesController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_admin, except: [:show, :edit_information, :update_information]

  def index
  end

  def show
    @employee = Employee.find(params[:id])
    verify_access(@employee)
  end

  def edit_information
    @employee = Employee.find(params[:id])
    verify_access(@employee)
  end

  def edit_compensation
    @employee = Employee.find(params[:id])
  end

  def update_information
    @employee = Employee.find(params[:id])
    verify_access(@employee)
    @employee.update!(personal_params)
    flash[:success] = "Personal information updated successfully"
    redirect_to company_employee_path(current_company.company_name, @employee)
  end

  def update_compensation
    @employee = Employee.find(params[:id])
    @employee.update!(compensation_params)
    flash[:success] = "Compensation information updated successfully"
    redirect_to company_employee_path(current_company.company_name, @employee)
  end

  private

  def verify_access(employee)
    if (current_user != employee && !current_user.admin)
      flash[:alert] = "You need to be an administrator to access this page."
      redirect_to root_path
    end
  end

  def personal_params
    params.require(:employee).permit(:email, :address, :phone)
  end

  def compensation_params
    params.require(:employee).permit(:salary, :bonus, :health_insurance, :matching, :pto)
  end
end
