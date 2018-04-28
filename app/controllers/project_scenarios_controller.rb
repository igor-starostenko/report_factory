# frozen_string_literal: true

# Provides logic and interface for Project Scenarios API
class ProjectScenariosController < BaseProjectsController
  before_action :set_project

  def index
    @project_scenarios = RspecExample.all
    # render jsonapi: @project_scenarios, status: :ok
  end
end
