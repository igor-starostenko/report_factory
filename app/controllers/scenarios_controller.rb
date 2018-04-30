# frozen_string_literal: true

# Provides logic and interface for Scenarios API
class ScenariosController < BaseProjectsController
  before_action :set_projects

  def index
    render jsonapi: @projects,
           class: { Project: SerializableScenario },
           status: :ok
  end

  private

  def set_projects
    @projects = Project.with_report_examples
  end
end
