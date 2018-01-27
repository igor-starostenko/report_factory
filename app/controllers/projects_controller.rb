# frozen_string_literal: true

# Provides logic and interface for Projects API
class ProjectsController < BaseProjectsController
  before_action :set_project, only: %i[show update destroy]
  before_action :require_admin, only: %i[destroy]

  PROJECT_ATTRIBUTES = %i[project_name].freeze

  def index
    @projects = Project.all
    render jsonapi: @projects, status: :ok
  end

  def show
    render jsonapi: @project, status: :ok
  end

  def create
    @project = Project.new(attributes(:project))

    if @project.save
      render jsonapi: @project, status: :created
    else
      render jsonapi_errors: @project.errors, status: :bad_request
    end
  end

  def update
    if @project.update(attributes(:project))
      render jsonapi: @project, status: :ok
    else
      render jsonapi_errors: @project.errors, status: :bad_request
    end
  end

  def destroy
    @project.destroy
    text = "Project #{@project.project_name} was deleted successfully"
    render json: { message: text }, status: :ok
  end
end
