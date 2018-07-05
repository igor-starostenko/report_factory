# frozen_string_literal: true

# Provides logic and interface for Project Reports API
class ProjectReportsController < BaseProjectsController
  before_action :set_project, :set_project_report

  def index
    render jsonapi: @project_reports, status: :ok
  end

  private

  def set_project_report
    @project_reports = Report.includes(:project, reportable: :summary)
                             .where(project_id: @project.id)
  end
end
