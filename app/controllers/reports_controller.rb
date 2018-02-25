# frozen_string_literal: true

# Provides logic and interface for Reports API
class ReportsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 30)
    @reports = paginate(Report.all, per_page: per_page)
    render jsonapi: @reports, status: :ok
  end

  def show
    @report = Report.find(params.fetch(:id))
    render jsonapi: @report, status: :ok
  end
end
