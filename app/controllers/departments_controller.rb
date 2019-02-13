class DepartmentsController < ApplicationController
  before_action :authenticate_admin
  before_action :verify_access, only: :show

  def index
    @departments = current_company.departments
  end

  def show
    @department = Department.find_by(id: params[:id])
    @employees = @department.employees.order(salary: :desc)
  end

  private

  def verify_access
    return if current_company.departments.include? Department.find_by(id: params[:id])
    flash[:alert] = "You need to be an administrator of this company to access this page"
    redirect_to root_path
  end

end