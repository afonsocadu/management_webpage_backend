class EmployeesController < ApplicationController
  def index
    employees = Employee.left_joins(:project).select(:id, :user_name, :title, :technologies)

    render status: 200,
           json: employees
  end

  def destroy
    employee = Employee.find(params[:id])

    if employee
      employee.destroy
      render json: { message: 'Employee deleted succesfully!' }
    else
      render json: { error: 'Employee not found' },  status: :unprocessable_entity
    end
  end
end
