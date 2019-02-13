class CompaniesController < ApplicationController
  before_action :authenticate_admin

  def show
    @company = current_company
    @top_earners = Employee.top_earners_by_department(@company)
  end
end
