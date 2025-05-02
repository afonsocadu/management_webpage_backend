class ProjectsController < ApplicationController

  # Returns a list of projects with specific information
  def index
    projects_data = Projects::Index.new.call

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

    employees = Projects::FilterEligibleEmployees.new(employees_name, project).call

    if project.update(employees: employees[:employee_to_update])
      render status: :ok, json: { updated_employees: project.employees, employees_not_updated: employees[:employees_not_updated=] }
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
end
