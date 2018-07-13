# frozen_string_literal: true

# Provides logic and interface for Project Reports API
class ProjectReportsController < BaseProjectsController
  before_action :set_project

  def index
    render jsonapi: @project.reports, status: :ok
  end
end
