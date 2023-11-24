class ProjectsController < ApplicationController
  def index
    projects = Project.all

    render status: 200,
           json: projects.as_json
  end
end
