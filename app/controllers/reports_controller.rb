# frozen_string_literal: true

# Provides logic and interface for Reports API
class ReportsController < ApplicationController
  def index
    @project = Project.find_by(project_name: project_name)
    return render_not_found unless @project
    @reports = Report.where(project_id: @project.id)
    render jsonapi: @reports, status: :ok
  end

  private

  def project_name
    params.fetch(:project_name).split('_').map(&:capitalize).join(' ')
  end

  def render_not_found
    render json: { message: 'Reports Not Found' },
           status: :not_found
  end
end
