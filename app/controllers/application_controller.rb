class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :current_company
  before_action :employee_list

  private

  def authenticate_user
    return if current_user&.company == current_company
    flash[:alert] = "You need to authenticate first."
    redirect_to root_path
  end

  def authenticate_admin
    return if current_user&.admin && current_user.company == current_company
    flash[:alert] = "You need to be an administrator to access this page."
    if current_user&.company == current_company
      redirect_to company_employee_path(current_company, current_user)
    else
      redirect_to root_path
    end
  end

  def current_user
    Employee.find_by(id: session[:user])
  end

  def current_company
    company = params[:company_name] || params[:name]
    Company.find_by(company_name: company)
  end

  def employee_list
    if current_company
      @employees = current_company.employees
    else
      @employees = Employee.all
    end
  end

end
