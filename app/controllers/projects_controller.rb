class ProjectsController < ApplicationController

  # Returns a list of projects with specific information
  def index
    projects = Project.all

    render status: 200,
           json: projects
  end

  # Creates a new project based on the provided parameters,

  def create
    title = params.require(:title)
    project = Project.new(title: title)

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
end
