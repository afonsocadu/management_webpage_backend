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
    data_updated = { }

    if params[:technology]
      technologies = params[:technology].map { |tech| Technology.find_by(name: tech) }

      data_updated[:technologies] = technologies
    else
      data_updated[:technologies] = employee.technologies.pluck(:name)
    end

    if params[:project]
      project = Project.find_by(title: params[:project])

      data_updated[:project] = project
    else
      project_title = employee.project.title

      data_updated[:project] = Project.find_by!(title: project_title)
    end

    if params[:user_name]
      user_name = params[:user_name]

      data_updated[:user_name] = user_name
    else
      data_updated[:user_name] = employee.user_name
    end

    if employee.update(data_updated)
      render status: :ok, json: employee
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not updated!' }
    end
  end

  # Creates a new employee based on the provided parameters,
  def create
    project_title = params.require(:project)
    user_name = params.require(:user_name)
    technology_name = params.require(:technologies)

    project = Project.find_by(title: project_title)

    technology = Technology.find_by(name: technology_name)

    employee = Employee.new(
      user_name: user_name,
      project: project
    )

    employee.technologies << technology

    if employee.save
      render status: :ok, json: {
        id: employee.id,
        user_name: employee.user_name,
        title: employee.project.title,
        technologies: employee.technologies.pluck(:name)
      }
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not created!' }
    end
  end
end
