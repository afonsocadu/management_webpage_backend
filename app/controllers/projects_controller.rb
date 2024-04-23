class ProjectsController < ApplicationController

  # Returns a list of projects with specific information
  def index
    projects = Project.includes(:employees)

    projects_data = projects.map do |project|
       {
         id: project.id,
         title: project.title,
         associated_employees: project.employees.pluck(:user_name),
         employees_available: Employee.can_be_associated_to_project(project.title).pluck(:user_name),
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
      render status: :unprocessable_entity, json: { error: "The project '#{project.title}' was not created." }
    end
  end

  # Deletes an project based on the provided `id`.
  def destroy
    project = Project.find(params[:id])

    if project.destroy
      render json: { message: 'Project deleted successfully!' }
    else
      render json: { error: "An error occurred when trying to delete the project #{project.title}" }, status: :unprocessable_entity
    end
  end

  # Updates the employees associated with a project
  def update_employees
    project_id = params.require(:project_id)
    employees_name = params.dig(:updated_data, :employees) || []

    project = Project.find(project_id)

    employee_to_update = []
    employees_not_updated = []

    employees_name.each do |employee_name|
      employee = Employee.find_by(user_name: employee_name)

      if employee_valid?(employee, project)
          employee_to_update << employee
      else
        employees_not_updated << employee
      end
    end

    if project.update(employees: employee_to_update)
      render status: :ok, json: { updated_employees: project.employees, employees_not_updated: employees_not_updated }
    else
      render status: :unprocessable_entity, json: { error: "The employees were not associated with the project '#{project.title}'." }
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
      render status: :unprocessable_entity, json: { error: "The technologies were not associated with the project '#{project.title}'." }
    end
  end

  # Updates the title of the project
  def update
    project = Project.find(params[:id])
    project_title = params.require(:updated_data).permit(:title)

    if project.update(project_title)
      render status: :ok, json: project
    else
      render status: :unprocessable_entity, json: { error: "The title was not associated with the project '#{project.title}'." }
    end
  end

  private

  # Verify if the associated employee has the necessary technology.
  def employee_valid?(employee, project)
    return false if project.nil? || employee.nil?

    project_technologies = project.technologies.pluck(:name)

    employee_technologies = employee.technologies.pluck(:name)

    return employee_technologies.any? { |tech| project_technologies.include?(tech) }
  end
end
