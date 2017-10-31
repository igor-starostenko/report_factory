# frozen_string_literal: true

# Provides logic and interface for Reports API
class ReportsController < ApplicationController
  before_action :set_project

  def index
    @reports = Report.where(project_id: @project.id)
    render jsonapi: @reports, status: :ok
  end
end
