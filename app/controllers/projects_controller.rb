class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    render jsonapi: @projects
  end

  def show
    @project = Project.find_by(project_name: project_name)
    render jsonapi: @project
  end

  def create
    @project = Project.new(project_attributes)

    if @project.save
      render jsonapi: @project, status: :created
    else
      render jsonapi_errors: @project.errors
    end
  end

  private

  def project_attributes
    project_params.fetch(:attributes, {})
  end

  def project_params
    # params.require(:project).permit(:project_name)
    params.require(:data).permit(:type, {
      attributes: %i[project_name]
    })
  end

  def update
    # TODO: add logic
  end
end
