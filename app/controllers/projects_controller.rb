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

    validate_create_employee_technologies(params)

    technologies_names = params.require(:technologies)

    technologies_names.each do |technology|
      technology = Technology.find_by(name: technology)

      project.technologies << technology
    end

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

  def update_employees
    validate_update_employee_technologies(params)

    project = Project.find(params[:projectId])
    updated_data = params[:updatedData]

    if updated_data
      employee_to_update = []
      employees = updated_data[:employees]

      employees.each do |employee|
        employee_to_update << Employee.find_by(user_name: employee )
      end

      project.employees = employee_to_update

      if project.save
        render status: :ok, json: project
      else
        render status: :unprocessable_entity, json: { error: 'Project was not updated!' }
      end
    end
  end

  def update_technologies
    project = Project.find(params[:projectId])
    updated_data = params[:updatedData]

    if updated_data
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
  end

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

  # Adds employees to the provided project based on the employee usernames passed as parameters.
  def add_employees_to_project(project)
    if params[:employees]
      employees = params[:employees]

      return unless employees.present?

      employees.each do |employee|

        employee_to_add = Employee.available.find_by(user_name: employee)

        project.employees << employee_to_add if employee_to_add
      end
    end
  end

  def validate_create_employee_technologies(params)
    employees = params[:employees]

    unless employees.nil?
      errors = []

      employees.each do |employee|
        employee_technologies = Employee.find_by(user_name: employee).technologies.pluck(:name)

        project_technologies = params[:technologies]

        unless employee_technologies.any? { |tech| project_technologies.include?(tech) }
          render json: { errors: errors }, status: :bad_request
          return
        end
      end
    end
  end

  def validate_update_employee_technologies(params)
    byebug
    data = params[:updatedData]

    unless data.nil?

      employees = data.require(:employees)
      errors = []

      employees.each do |employee|
        employee_technologies = Employee.find_by(user_name: employee).technologies.pluck(:name)

        project_technologies = Project.find_by(id: params[:projectId]).technologies.pluck(:name)
        unless employee_technologies.any? { |tech| project_technologies.include?(tech) }
          render json: { errors: errors }, status: :bad_request
          return
        end
      end
    end
  end
end
