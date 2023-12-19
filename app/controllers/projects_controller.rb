class ProjectsController < ApplicationController
  def index
    projects = Project.all

    render status: 200,
           json: projects
  end

  def create
    begin
      title = params[:title]
      unless title
        render status: :no_content, json: { error: 'Title is required' }
        return
      end

      project = Project.new(title: title)
      if project.save
        render status: :ok, json: project
      else
        render status: :unprocessable_entity, json: { error: 'Project was not created!' }
      end
    end
  end
end
