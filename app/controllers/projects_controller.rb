# frozen_string_literal: true

# Provides logic and interface for Projects API
class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    render jsonapi: @projects
  end

  def show
    @project = Project.find_by(project_name: project_name)
    return render_not_found unless @project
    render jsonapi: @project
  end

  def create
    logger.info(project_attributes)
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
    params.require(:data).permit(:type, attributes: %i[project_name])
  end

  def update
    # TODO: add logic
  end

  def project_name
    params.fetch(:project_name).split('_').map(&:capitalize).join(' ')
  end

  def render_not_found
    render json: { message: 'Project Not Found' },
                   status: :not_found
  end
end
