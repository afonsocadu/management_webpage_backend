class EmployeesController < ApplicationController
  def index
    employees = Employee.left_joins(:project).select(:id, :user_name, :title, :technologies)

    render status: 200,
           json: employees
  end
end
