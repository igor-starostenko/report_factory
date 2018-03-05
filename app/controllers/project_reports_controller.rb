# frozen_string_literal: true

# Provides logic and interface for Project Reports API
class ProjectReportsController < BaseProjectsController
  before_action :set_project

  def index
    @project_reports = Report.where(project_id: @project.id)
    render jsonapi: @project_reports, status: :ok
  end
end
