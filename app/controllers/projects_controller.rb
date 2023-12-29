class ProjectsController < ApplicationController
  def index
    projects = Project.all

    render status: 200,
           json: projects
  end

  def create
      title = params.require(:title)
      project = Project.new(title: title)

      if project.save
        render status: :ok, json: project
      else
        render status: :unprocessable_entity, json: { error: 'Project was not created!' }
      end
    end
  end
