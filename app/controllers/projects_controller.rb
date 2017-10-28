# frozen_string_literal: true

# Provides logic and interface for Projects API
class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show update]

  def index
    @projects = Project.all
    render jsonapi: @projects, status: :ok
  end

  def show
    render jsonapi: @project, status: :ok
  end

  def create
    @project = Project.new(project_attributes)

    if @project.save
      render jsonapi: @project, status: :created
    else
      render jsonapi_errors: @project.errors, status: :bad_request
    end
  end

  def update
    if @project.update(project_attributes)
      render jsonapi: @project, status: :ok
    else
      render jsonapi_errors: @project.errors, status: :bad_request
    end
  end

  private

  def project_attributes
    project_params.fetch(:attributes, {})
  end

  def project_params
    params.require(:data).permit(:type, attributes: %i[project_name])
  end
end
