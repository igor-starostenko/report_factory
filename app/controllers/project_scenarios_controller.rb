# frozen_string_literal: true

# Provides logic and interface for Project Scenarios API
class ProjectScenariosController < BaseProjectsController
  before_action :set_project

  def index
    render jsonapi: @project,
           class: { Project: SerializableProjectScenario },
           status: :ok
  end
end
