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

    technologies_names.each do |technology|
      technology = Technology.find_by(name: technology)

      project.technologies << technology
    end

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
    project_id = params.require(:projectId)
    employees = params.dig(:updatedData, :employees)

    validation = validate_employee(employees, project_id)

    project = Project.find(project_id)

    if validation
      employee_to_update = []

      employees.each do |employee|
        employee_to_update << Employee.find_by(user_name: employee )
      end

      project.employees = employee_to_update

      if project.save
        render status: :ok, json: project.employees
      else
        render status: :unprocessable_entity, json: { error: 'Project was not updated!' }
      end
    else
      render status: :unprocessable_entity, json: { error: 'Validation failed!' }
    end
  end

  # Updates the technologies associated with a project
  def update_technologies
    project = Project.find(params[:projectId])
    updated_data = params.require(:updatedData)

    technologies_to_update = []

    technologies = updated_data[:technologies]

    technologies.each do |technology|
      technology = Technology.find_by(name: technology)

      technologies_to_update << technology
    end

    if project.update(technologies: technologies_to_update)
      render status: :ok, json: project.technologies
    else
      render status: :unprocessable_entity, json: { error: 'Technologies was not updated!' }
    end
  end

  # Updates the title of the project
  def update_title
    project = Project.find(params[:projectId])
    updated_title = params.require(:updatedData)[:projectName]
    project.title = updated_title

    if project.update(title: updated_title)
      render status: :ok, json: project
    else
      render status: :unprocessable_entity, json: { error: 'Title was not updated!' }
    end
  end

  private

  # Verify if the associated employee has the necessary technology.
  def validate_employee(employees, project_id = nil)
    return true if project_id.nil? || employees.empty?

    project_technologies = Project.find_by(id: params[:projectId]).technologies.pluck(:name)

    employees.each do |employee|
      employee_technologies = Employee.find_by(user_name: employee).technologies.pluck(:name)

      return true if employee_technologies.any? { |tech| project_technologies.include?(tech) }
    end

    false
  end
end
