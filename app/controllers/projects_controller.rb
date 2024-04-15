class ProjectsController < ApplicationController

  # Returns a list of projects with specific information
  def index
    projects = Project.includes(:employees)

    projects_data = projects.map do |project|
       {
         id: project.id,
         title: project.title,
         associated_employees: project.employees.pluck(:user_name),
         employees_available: Employee.available.pluck(:user_name),
         technologies: project.technologies.pluck(:name)
       }
    end

    render status: 200,
           json: projects_data
  end

  # Creates a new project based on the provided parameters,
  def create
    title = params.require(:title)
    project = Project.new(title: title)

    technologies_names = params.require(:technologies)

    technologies = Technology.where(name: technologies_names)

    project.technologies << technologies

    if project.save
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

  # Updates the employees associated with a project
  def update_employees
    project_id = params.require(:project_id)
    employees_name = params.dig(:updated_data, :employees)

    project = Project.find(project_id)

    employee_to_update = []
    employees_not_updated = []

    unless employees_name.nil?
      employees_name.each do |employee_name|
        employee = Employee.find_by(user_name: employee_name)
        validation = employee_valid?(employee, project)

        if validation
          employee_to_update << employee
        else
          employees_not_updated << employee
        end
      end
    end

    if project.update(employees: employee_to_update)
      render status: :ok, json: { updated_employees: project.employees, employees_not_updated: employees_not_updated }
    else
      render status: :unprocessable_entity, json: { error: 'Project was not updated!' }
    end
  end

  # Updates the technologies associated with a project
  def update_technologies
    project = Project.find(params[:project_id])
    updated_data = params.require(:updated_data)

    technologies_to_update = []

    technologies_names = updated_data[:technologies]

    technologies = Technology.where(name: technologies_names)

    technologies_to_update << technologies

    if project.update(technologies: technologies_to_update.flatten)
      render status: :ok, json: project.technologies
    else
      render status: :unprocessable_entity, json: { error: 'Technologies was not updated!' }
    end
  end

  # Updates the title of the project
  def update
    project = Project.find(params[:id])
    project_title = params.require(:updated_data)[:project_name]

    if project.update(title: project_title)
      render status: :ok, json: project
    else
      render status: :unprocessable_entity, json: { error: 'Title was not updated!' }
    end
  end

  private

  # Verify if the associated employee has the necessary technology.
  def employee_valid?(employee, project)
    return false if project.nil? || employee.nil?

    project_technologies = project.technologies.pluck(:name)

    employee_technologies = employee.technologies.pluck(:name)

    return true if employee_technologies.any? { |tech| project_technologies.include?(tech) }

    false
  end
end
