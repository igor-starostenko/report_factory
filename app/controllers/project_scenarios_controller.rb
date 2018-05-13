# frozen_string_literal: true

# Provides logic and interface for Project Scenarios API
class ProjectScenariosController < BaseProjectsController
  before_action :set_project

  def index
    render jsonapi: @project,
           class: { Project: SerializableScenario },
           status: :ok
  end

  private

  def set_project
    @project = Project.with_report_examples.by_name(project_name)
    return render_not_found(:project) unless @project
  end
end
