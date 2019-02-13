class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def login
    user = Employee.find(params[:employee])
    session[:user] = user.id
    redirect_to user.admin ? company_path(user.company) : company_employee_path(user.company, user)
  end

  def logout
    session[:user] = nil
    redirect_to root_path
  end
end