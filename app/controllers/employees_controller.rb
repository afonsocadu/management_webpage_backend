class EmployeesController < ApplicationController

  # Returns a list of employees with specific information
  def index
    employees = Employee.left_joins(:project).select(:id, :user_name, :title, :technologies)

    render status: 200,
           json: employees
  end

  # Deletes an employee based on the provided `id`.
  def destroy
    employee = Employee.find(params[:id])

    if employee.destroy
      render json: { message: 'Employee deleted successfully!' }
    else
      render json: { error: 'An error occurred when trying to delete the employee', details: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Updates the information of an employee based on the provided `id`.
  def update
    employee = Employee.find(params[:id])

    project_title = params.require(:project)

    project_id = Project.find_by!(title: project_title)&.id

    if employee.update(user_name: params[:user_name], project_id: project_id)
      render status: :ok, json: employee
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not updated!' }
    end
  end

  # Creates a new employee based on the provided parameters,
  def create
    title = params.require(:project)
    user_name = params.require(:user_name)

    project = Project.find_by(title: title)


    employee = Employee.new(
      user_name: user_name,
      project_id: project.id,
    )

    if employee.save
      render status: :ok, json: employee
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not created!' }
    end
  end
end
