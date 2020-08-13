class CompaniesController < ApplicationController
  before_action :authenticate_admin

  def show
    @company = current_company
    @top_earners = @company.top_three_earners_by_department
  end
end
