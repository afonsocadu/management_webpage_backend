class ProjectsController < ApplicationController

  # Returns a list of projects with specific information
  def index
    projects = Project.includes(:employees)

    projects_data = projects.map do |project|

       { id: project.id, title: project.title, employees: project.employees.pluck(:user_name) }
    end

    render status: 200,
           json: projects_data
  end

  # Creates a new project based on the provided parameters,
  def create
    title = params.require(:title)
    project = Project.new(title: title)

    if project.save
      add_employees_to_project(project)
      render status: :ok, json: project
    else
      render status: :unprocessable_entity, json: { error: project.errors.full_messages.to_sentence }
    end
  end

  # Deletes an project based on the provided `id`.

  def destroy
    project = Project.find(params[:id])

    if project.destroy
      render json: { message: 'Project deleted successfully!' }
    else
      render json: { error: 'An error occurred when trying to delete the project', details: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Updates the information of an project based on the provided `id`.
  def update
    project = Project.find(params[:id])
    title = params[:title]

    if project.update(title: title)
      render status: :ok, json: project
    else
      render status: :unprocessable_entity, json: { error: project.errors.full_messages.to_sentence }
    end
  end

  private

  # Adds employees to the provided project based on the employee usernames passed as parameters.
  def add_employees_to_project(project)
    employees = params[:employees]

    return unless employees.present?

    employees.each do |employee|
      employee_toa_add = Employee.find_by(user_name: employee)

      project.employees << employee_toa_add if employee_toa_add
    end
  end
end
