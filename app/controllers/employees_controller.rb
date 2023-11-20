class EmployeesController < ApplicationController
  def index
    employees = Employee.includes(:project).all

    render status: 200,
           json: employees.as_json(include: { project: { only: :title } })
  end
end
