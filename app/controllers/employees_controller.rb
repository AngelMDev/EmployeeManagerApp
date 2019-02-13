class EmployeesController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_admin, except: [:show, :edit_information, :update_information]
  before_action :verify_access, except: :index

  def index
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def edit_information
    @employee = Employee.find(params[:id])
  end

  def edit_compensation
    @employee = Employee.find(params[:id])
  end

  def update_information
    @employee = Employee.find(params[:id])
    if @employee.update(personal_params)
      flash[:success] = "Personal information updated successfully"
      redirect_to company_employee_path(current_company.company_name, @employee)
    else
      flash[:alert] = @employee.errors.full_messages.to_sentence
      redirect_to edit_information_company_employee_path(current_company.company_name, @employee)
    end
  end

  def update_compensation
    @employee = Employee.find(params[:id])
    if @employee.update(compensation_params)
      flash[:success] = "Compensation information updated successfully"
      redirect_to company_employee_path(current_company.company_name, @employee)
    else
      flash[:alert] = @employee.errors.full_messages.to_sentence
      redirect_to edit_compensation_company_employee_path(current_company.company_name, @employee)
    end
  end

  private

  def verify_access
    employee = Employee.find(params[:id])
    # If the user is the same OR if the user is an administrator for the company THEN allow access.
    return if (current_user == employee || (current_user.admin && current_user.company == employee.company))
    flash[:alert] = "You need to be an administrator of this company to access this page"
    redirect_to root_path
  end

  def personal_params
    params.require(:employee).permit(:email, :address, :phone)
  end

  def compensation_params
    params.require(:employee).permit(:salary, :bonus, :health_insurance, :matching, :pto)
  end
end
