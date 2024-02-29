class EmployeesController < ApplicationController

  # Returns a list of employees with specific information
  def index
    employees = Employee.left_joins(:project).select(:id, :user_name, :title)

    employees_data = employees.map do |employee|
      {
        id: employee.id,
        user_name: employee.user_name,
        title: employee.title,
        technologies: employee.technologies.pluck(:name)
      }
    end

    render status: 200,
           json: employees_data
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
    data_updated = params.permit(:user_name)

    if params[:technology]
      technologies = params[:technology].map { |tech| Technology.find_by(name: tech) }

      data_updated[:technologies] = technologies
    end

    if params[:project]
      project = Project.find_by(title: params[:project])

      data_updated[:project] = project
    end

    if employee.update(data_updated)
      render status: :ok, json: employee
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not updated!' }
    end
  end

  # Creates a new employee based on the provided parameters,
  def create
    data_params = { user_name: params.require(:user_name) }

    if params[:project]
      project = Project.find_by(title: params[:project])
      data_params = { user_name: params.require(:user_name), project: project }
    end

    employee = Employee.new(data_params)

    technology_name = params.require(:technologies)
    technology = Technology.find_by(name: technology_name)

    employee.technologies << technology

    if employee.save
      render status: :ok, json: {
        employee: employee
      }
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not created!' }
    end
  end
end
